{-# OPTIONS_GHC -O2 -fllvm #-}
{-# LANGUAGE FlexibleContexts, BangPatterns #-}

import Data.Time.Clock.POSIX ( getPOSIXTime ) -- for timing

import Data.Int ( Int64 )
import Data.Word ( Word32, Word64 )
import Data.Bits ( Bits( (.&.), (.|.), shiftL, shiftR ) )
import Control.Monad ( unless, when, forM_ )
import Control.Monad.ST ( ST, runST )
import Data.Array.ST ( runSTUArray )
import Data.Array.Base ( UArray(..), IArray(unsafeAt), listArray, elems, assocs,
                         MArray( unsafeNewArray_, newArray, unsafeRead, unsafeWrite ),
                         STUArray,  unsafeFreezeSTUArray, castSTUArray )

countPrimes :: Word64 -> Int64
countPrimes n =
  if n < 3 then (if n < 2 then 0 else 1) else
  let sqrtn = truncate $ sqrt $ fromIntegral n
      qdrtn = truncate $ sqrt $ fromIntegral sqrtn
      rtlmt = (sqrtn - 3) `div` 2
      qrtlmt = (qdrtn - 3) `div` 2
      oddPrimes@(UArray _ _ psz _) = runST $ do -- UArray of odd primes...
        cmpsts <- newArray (0, rtlmt) False :: ST s (STUArray s Int Bool)
        forM_ [ 0 .. qrtlmt ] $ \ i -> do
          t <- unsafeRead cmpsts i
          unless t $ do
            let sqri = (i + i) * (i + 3) + 3
                bp = i + i + 3
            forM_ [ sqri, sqri + bp .. rtlmt ] $ \ c ->
              unsafeWrite cmpsts c True
        fcmpsts <- unsafeFreezeSTUArray cmpsts
        let !numoprms = sum $ [ 1 | False <- elems fcmpsts ]
            prms = [ fromIntegral $ i + i + 3 | (i, False) <- assocs fcmpsts ]
        return $ listArray (0, numoprms - 1) prms :: ST s (UArray Int Word32)
      phi x a =
        if a < 1 then x - (x `shiftR` 1) else
        let na = a - 1
            p = fromIntegral $ unsafeAt oddPrimes na in
        if x < p then 1 else
        phi x na - phi (x `div` p) na

  in fromIntegral (phi n psz) + fromIntegral psz

main :: IO ()
main = do
  strt <- getPOSIXTime
  mapM_ (\n -> putStrLn $ show n ++ "\t" ++ show (countPrimesx (10^n))) [ 0 .. 9 ]
  stop <- getPOSIXTime
  let elpsd = round $ 1e3 * (stop - strt) :: Int64
  putStrLn $ "This took " ++ show elpsd ++ " milliseconds."
