{-# OPTIONS_GHC -O2 -fllvm #-} -- use LLVM for about double speed!

import Data.Int ( Int64 )
import Data.Word ( Word64 )
import Data.Bits ( Bits(shiftR) )
import Data.Array.Base ( IArray(unsafeAt), UArray(UArray),
                         MArray(unsafeWrite), unsafeFreezeSTUArray )
import Control.Monad ( forM_ )
import Data.Array.ST ( MArray(newArray), runSTUArray )

type Prime = Word64

cSieveBufferRange :: Int
cSieveBufferRange = 2^17 * 8 -- CPU L2 cache in bits

primes :: () -> [Prime]
primes() = 2 : _Y (listPagePrms . pagesFrom 0) where
  _Y g = g (_Y g) -- non-sharing multi-stage fixpoint combinator
  szblmt = cSieveBufferRange - 1
  listPagePrms pgs@(hdpg@(UArray lwi _ rng _) : tlpgs) =
    let loop i | i >= fromIntegral rng = listPagePrms tlpgs
               | unsafeAt hdpg i = loop (i + 1)
               | otherwise = let ii = lwi + fromIntegral i in
                             case fromIntegral $ 3 + ii + ii of
                               p -> p `seq` p : loop (i + 1) in loop 0
  makePg lwi bps = runSTUArray $ do
    let limi = lwi + fromIntegral szblmt
        bplmt = floor $ sqrt $ fromIntegral $ limi + limi + 3
        strta bp = let si = fromIntegral $ (bp * bp - 3) `shiftR` 1
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
