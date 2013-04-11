import Data.List
import HFM.Primes(isPrime)
import Control.Monad
import Control.Arrow

int2bin = reverse.unfoldr(\x -> if x==0 then Nothing
                                else Just ((uncurry.flip$(,))$divMod x 2))

trialfac m = take 1. dropWhile ((/=1).(\q -> foldl (((`mod` q).).pm) 1 bs)) $ qs
  where qs = filter (liftM2 (&&) (liftM2 (||) (==1) (==7) .(`mod`8)) isPrime ).
              map (succ.(2*m*)). enumFromTo 1 $ m `div` 2
        bs = int2bin m
        pm n b = 2^b*n*n
