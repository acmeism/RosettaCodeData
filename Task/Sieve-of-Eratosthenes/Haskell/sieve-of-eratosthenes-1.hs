{-# LANGUAGE FlexibleContexts #-} -- too lazy to write contexts...
{-# OPTIONS_GHC -O2 #-}

import Control.Monad.ST ( runST, ST )
import Data.Array.Base ( MArray(newArray, unsafeRead, unsafeWrite),
                         IArray(unsafeAt),
                         STUArray, unsafeFreezeSTUArray, assocs )
import Data.Time.Clock.POSIX ( getPOSIXTime ) -- for timing...

primesTo :: Int -> [Int] -- generate a list of primes to given limit...
primesTo limit = runST $ do
  let lmt = limit - 2-- raw index of limit!
  cmpsts <- newArray (2, limit) False -- when indexed is true is composite
  cmpstsf <- unsafeFreezeSTUArray cmpsts -- frozen in place!
  let getbpndx bp = (bp, bp * bp - 2) -- bp -> bp, raw index of start cull
      cullcmpst i = unsafeWrite cmpsts i True -- cull composite by raw ndx
      cull4bpndx (bp, si0) = mapM_ cullcmpst [ si0, si0 + bp .. lmt ]
  mapM_ cull4bpndx
        $ takeWhile ((>=) lmt . snd) -- for bp's <= square root limit
                    [ getbpndx bp | (bp, False) <- assocs cmpstsf ]
  return [ p | (p, False) <- assocs cmpstsf ] -- non-raw ndx is prime

-- testing...
main :: IO ()
main = do
  putStrLn $ "The primes up to 100 are " ++ show (primesTo 100)
  putStrLn $ "The number of primes up to a million is " ++
               show (length $ primesTo 1000000)
  let top = 1000000000
  start <- getPOSIXTime
  let answr = length $ primesTo top
  stop <- answr `seq` getPOSIXTime -- force result for timing!
  let elpsd =  round $ 1e3 * (stop - start) :: Int

  putStrLn $ "Found " ++ show answr ++ " to " ++ show top ++
               " in " ++ show elpsd ++ " milliseconds."
