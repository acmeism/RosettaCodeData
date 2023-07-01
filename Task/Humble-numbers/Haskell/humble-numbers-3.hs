{-# OPTIONS_GHC -O2 #-}
{-# LANGUAGE FlexibleContexts #-}

import Data.Word (Word64)
import Data.Bits (shiftR)
import Data.Function (fix)
import Data.Array.Unboxed (UArray, elems)
import Data.Array.Base (MArray(newArray, unsafeRead, unsafeWrite))
import Data.Array.IO (IOUArray)
import Data.List (intercalate)
import Data.Time.Clock.POSIX (getPOSIXTime)
import Data.Array.Unsafe (unsafeFreeze)

cNumDigits :: Int
cNumDigits = 877

cShift :: Int
cShift = 50
cFactor :: Word64
cFactor = 2^cShift
cLogOf10 :: Word64
cLogOf10 = cFactor
cLogOf7 :: Word64
cLogOf7 = round $ (logBase 10 7 :: Double) * fromIntegral cFactor
cLogOf5 :: Word64
cLogOf5 = round $ (logBase 10 5 :: Double) * fromIntegral cFactor
cLogOf3 :: Word64
cLogOf3 = round $ (logBase 10 3 :: Double) * fromIntegral cFactor
cLogOf2 :: Word64
cLogOf2 = cLogOf10 - cLogOf5
cLogLmt :: Word64
cLogLmt = fromIntegral cNumDigits * cLogOf10

humbles :: () -> [Integer]
humbles() = 1 : foldr u [] [2,3,5,7] where
  u n s = fix (merge s . map (n*) . (1:)) where
    merge a [] = a
    merge [] b = b
    merge a@(x:xs) b@(y:ys) | x < y     = x : merge xs b
                            | otherwise = y : merge a ys

-------------------------- TEST ---------------------------
main :: IO ()
main = do
  putStrLn "First 50 humble numbers:"
  mapM_ (putStrLn . concat) $
    chunksOf 10 $ justifyRight 4 ' ' . show <$> take 50 (humbles())
  putStrLn $ "\nCount of humble numbers for each digit length 1-"
                  ++ show cNumDigits ++ ":"
  putStrLn "Digits       Count              Accum"
  strt <- getPOSIXTime
  mbins <- newArray (0, cNumDigits - 1) 0 :: IO (IOUArray Int Int)
  let loopw w =
        if w >= cLogLmt then return () else
        let loopx x =
              if x >= cLogLmt then loopw (w + cLogOf2) else
              let loopy y =
                    if y >= cLogLmt then loopx (x + cLogOf3) else
                    let loopz z =
                          if z >= cLogLmt then loopy (y + cLogOf5) else do
                            let ndx = fromIntegral (z `shiftR` cShift)
                            v <- unsafeRead mbins ndx
                            unsafeWrite mbins ndx (v + 1)
                            loopz (z + cLogOf7) in loopz y in loopy x in loopx w
  loopw 0
  stop <- getPOSIXTime
  bins <- unsafeFreeze mbins :: IO (UArray Int Int)
  mapM_ putStrLn $ format $ elems bins
  putStrLn $ "Counting took " ++ show (realToFrac (stop - strt)) ++ " seconds."

------------------------- DISPLAY -------------------------
chunksOf :: Int -> [a] -> [[a]]
chunksOf n = go where
  go [] = []
  go ilst = take n ilst : go (drop n ilst)

justifyRight :: Int -> a -> [a] -> [a]
justifyRight n c = (drop . length) <*> (replicate n c ++)

commaString :: String -> String
commaString =
  let grpsOf3 [] = []
      grpsOf3 s = let (frst, rest) = splitAt 3 s in frst : grpsOf3 rest
  in reverse . intercalate "," . grpsOf3 . reverse

format :: [Int] -> [String]
format = go (0 :: Int) 0 where
  go _ _ [] = []
  go i cacc (hd : tl) =
    let ni = i + 1
        ncacc = cacc + hd
        str = justifyRight 4 ' ' (show ni) ++
                justifyRight 14 ' ' (commaString $ show hd) ++
                justifyRight 19 ' ' (commaString $ show ncacc)
    in str : go ni ncacc tl
