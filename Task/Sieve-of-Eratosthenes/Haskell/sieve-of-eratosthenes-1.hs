import Control.Monad (forM_, when)
import Control.Monad.ST
import Data.Array.ST
import Data.Array.Unboxed

primeSieve :: Integer -> UArray Integer Bool
primeSieve top = runSTUArray $ do
    a <- newArray (2,top) True           -- :: ST s (STUArray s Integer Bool)
    let r = ceiling . sqrt $ fromInteger top
    forM_ [2..r] $ \i -> do
      ai <- readArray a i
      when ai $ do
        forM_ [i*i,i*i+i..top] $ \j -> do
          writeArray a j False
    return a

-- Return primes from sieve as list:
primesTo :: Integer -> [Integer]
primesTo top = [p | (p,True) <- assocs $ primeSieve top]
