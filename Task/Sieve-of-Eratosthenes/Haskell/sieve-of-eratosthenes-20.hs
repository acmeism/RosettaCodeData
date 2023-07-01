{-# LANGUAGE  FlexibleContexts #-}
{-# OPTIONS_GHC -O2 -fllvm #-} -- use LLVM for about double speed!

import Data.Time.Clock.POSIX ( getPOSIXTime ) -- for timing

import Data.Int ( Int64 )
import Data.Word ( Word64 )
import Data.Bits ( Bits((.&.), (.|.), shiftL, shiftR, popCount) )
import Control.Monad.ST ( ST, runST )
import Data.Array.Base ( IArray(unsafeAt), UArray(UArray), STUArray,
                         MArray(unsafeRead, unsafeWrite), castSTUArray,
                         unsafeThawSTUArray, unsafeFreezeSTUArray )
import Control.Monad ( forM_ )
import Data.Array.ST ( MArray(newArray), runSTUArray )

type Prime = Word64

cSieveBufferRange :: Int
cSieveBufferRange = 2^17 * 8 -- CPU L2 cache in bits

type PrimeNdx = Int64
type SieveBuffer = UArray PrimeNdx Bool
cWHLPRMS :: [Prime]
cWHLPRMS = [ 2 ]
cFRSTSVPRM :: Prime
cFRSTSVPRM = 3
primesPages :: () -> [SieveBuffer]
primesPages() = _Y (pagesFrom 0 . listPagePrms) where
  _Y g = g (_Y g) -- non-sharing multi-stage fixpoint Y-combinator
  szblmt = fromIntegral (cSieveBufferRange `shiftR` 1) - 1
  makePg lwi bps = runSTUArray $ do
    let limi = lwi + fromIntegral szblmt
        mxprm = cFRSTSVPRM + fromIntegral (limi + limi)
        bplmt = floor $ sqrt $ fromIntegral mxprm
        strta bp = let si = fromIntegral $ (bp * bp - cFRSTSVPRM) `shiftR` 1
                   in if si >= lwi then fromIntegral $ si - lwi else
                   let r = fromIntegral (lwi - si) `mod` bp
                   in if r == 0 then 0 else fromIntegral $ bp - r
    cmpsts <- newArray (lwi, limi) False
    fcmpsts <- unsafeFreezeSTUArray cmpsts
    let cbps = if lwi == 0 then listPagePrms [fcmpsts] else bps
    forM_ (takeWhile (<= bplmt) cbps) $ \ bp ->
      forM_ (let sp = fromIntegral $ strta bp
             in [ sp, sp + fromIntegral bp .. szblmt ]) $ \c ->
        unsafeWrite cmpsts c True
    return cmpsts
  pagesFrom lwi bps = map (`makePg` bps)
                          [ lwi, lwi + fromIntegral szblmt + 1 .. ]

-- convert a list of sieve buffers to a list of primes...
listPagePrms :: [SieveBuffer] -> [Prime]
listPagePrms pgs@(pg@(UArray lwi _ rng _) : pgstl) = bsprm `seq` loop 0 where
  bsprm = cFRSTSVPRM + fromIntegral (lwi + lwi)
  loop i | i >= rng = listPagePrms pgstl
         | unsafeAt pg i = loop (i + 1)
         | otherwise = case bsprm + fromIntegral (i + i) of
                         p -> p `seq` p : loop (i + 1)

primes :: () -> [Prime]
primes() = cWHLPRMS ++ listPagePrms (primesPages())

-- very fast using popCount by words technique...
countSieveBuffer :: Int -> UArray PrimeNdx Bool -> Int64
countSieveBuffer lstndx sb = fromIntegral $ runST $ do
  cmpsts <- unsafeThawSTUArray sb :: ST s (STUArray s PrimeNdx Bool)
  wrdcmpsts <-
    (castSTUArray :: STUArray s PrimeNdx Bool ->
                      ST s (STUArray s PrimeNdx Word64)) cmpsts
  let lstwrd = lstndx `shiftR` 6
      lstmsk = 0xFFFFFFFFFFFFFFFE `shiftL` (lstndx .&. 63) :: Word64
      loop wi cnt
        | wi < lstwrd = do
          v <- unsafeRead wrdcmpsts wi
          case cnt - popCount v of ncnt -> ncnt `seq` loop (wi + 1) ncnt
        | otherwise = do
            v <- unsafeRead wrdcmpsts lstwrd
            return $ fromIntegral (cnt - popCount (v .|. lstmsk))
  loop 0 (lstwrd * 64 + 64)

-- count the remaining un-marked composite bits using very fast popcount...
countPrimesTo :: Prime -> Int64
countPrimesTo limit =
  let lmtndx = fromIntegral $ (limit - 3) `shiftR` 1
      loop (pg@(UArray lwi lmti rng _) : pgstl) cnt
        | lmti >= lmtndx =
          (cnt + countSieveBuffer (fromIntegral $ lmtndx - lwi) pg)
        | otherwise = loop pgstl (cnt + countSieveBuffer (rng - 1) pg)
  in if limit < 3 then if limit < 2 then 0 else 1
     else loop (primesPages()) 1

-- test it...
main :: IO ()
main = do
  let limit = 10^9 :: Prime

  strt <- getPOSIXTime
--  let answr = length $ takeWhile (<= limit) $ primes()-- slow way
  let answr = countPrimesTo limit -- fast way
  stop <- answr `seq` getPOSIXTime -- force evaluation of answr b4 stop time!
  let elpsd = round $ 1e3 * (stop - strt) :: Int64

  putStr $ "Found " ++ show answr
  putStr $ " primes up to " ++ show limit
  putStrLn $ " in " ++ show elpsd ++ " milliseconds."
