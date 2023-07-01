{-# OPTIONS_GHC -O2 #-}

import Data.Word (Word16)
import Data.Bits (shiftR, (.&.))
import Data.Function (fix)
import Data.List (group, intercalate)
import Data.Time.Clock.POSIX (getPOSIXTime)

--------------------- HUMBLE NUMBERS ----------------------
data LogRep = LogRep {-# UNPACK #-} !Double
                     {-# UNPACK #-} !Word16
                     {-# UNPACK #-} !Word16
                     {-# UNPACK #-} !Word16
                     {-# UNPACK #-} !Word16 deriving Show
instance Eq LogRep where
  (==) (LogRep la _ _ _ _) (LogRep lb _ _ _ _) = la == lb
instance Ord LogRep where
  (<=) (LogRep la _ _ _ _) (LogRep lb _ _ _ _) = la <= lb
logrep2Integer :: LogRep -> Integer
logrep2Integer (LogRep _ w x y z) = xpnd 2 w $ xpnd 3 x $ xpnd 5 y $ xpnd 7 z 1 where
  xpnd m v = go v m where
    go i mlt acc =
      if i <= 0 then acc else
      go (i `shiftR` 1) (mlt * mlt) (if i .&. 1 == 0 then acc else acc * mlt)
cOneLR :: LogRep
cOneLR = LogRep 0.0 0 0 0 0
cLgOf2 :: Double
cLgOf2 = logBase 10 2
cLgOf3 :: Double
cLgOf3 = logBase 10 3
cLgOf5 :: Double
cLgOf5 = logBase 10 5
cLgOf7 :: Double
cLgOf7 = logBase 10 7
cLgOf10 :: Double
cLgOf10 = cLgOf2 + cLgOf5
mulLR2 :: LogRep -> LogRep
mulLR2 (LogRep lg w x y z) = LogRep (lg + cLgOf2) (w + 1) x y z
mulLR3 :: LogRep -> LogRep
mulLR3 (LogRep lg w x y z) = LogRep (lg + cLgOf3) w (x + 1) y z
mulLR5 :: LogRep -> LogRep
mulLR5 (LogRep lg w x y z) = LogRep (lg + cLgOf5) w x (y + 1) z
mulLR7 :: LogRep -> LogRep
mulLR7 (LogRep lg w x y z) = LogRep (lg + cLgOf7) w x y (z + 1)

humbleLRs :: () -> [LogRep]
humbleLRs() = cOneLR : foldr u [] [mulLR2, mulLR3, mulLR5, mulLR7] where
  u nmf s = fix (merge s . map nmf . (cOneLR:)) where
    merge a [] = a
    merge [] b = b
    merge a@(x:xs) b@(y:ys) | x < y     = x : merge xs b
                            | otherwise = y : merge a ys

-------------------------- TEST ---------------------------
main :: IO ()
main = do
  putStrLn "First 50 Humble numbers:"
  mapM_ (putStrLn . concat) $
    chunksOf 10 $ justifyRight 4 ' ' . show <$> take 50 (map logrep2Integer $ humbleLRs())
  strt <- getPOSIXTime
  putStrLn "\nCount of humble numbers for each digit length 1-255:"
  putStrLn "Digits       Count              Accum"
  mapM_ putStrLn $ take 255 $ groupFormat $ humbleLRs()
  stop <- getPOSIXTime
  putStrLn $ "Counting took " ++ show (1.0 * (stop - strt)) ++ " seconds."

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
      grpsOf3 is = let (frst, rest) = splitAt 3 is in frst : grpsOf3 rest
  in reverse . intercalate "," . grpsOf3 . reverse

groupFormat :: [LogRep] -> [String]
groupFormat = go (0 :: Int) (0 :: Int) 0 where
  go _ _ _ [] = []
  go i cnt cacc ((LogRep lg _ _ _ _) : lrtl) =
    let nxt = truncate (lg / cLgOf10) :: Int in
    if nxt == i then go i (cnt + 1) cacc lrtl else
    let ni = i + 1
        ncacc = cacc + cnt
        str = justifyRight 4 ' ' (show ni) ++
                justifyRight 14 ' ' (commaString $ show cnt) ++
                justifyRight 19 ' ' (commaString $ show ncacc)
    in str : go ni 1 ncacc lrtl
