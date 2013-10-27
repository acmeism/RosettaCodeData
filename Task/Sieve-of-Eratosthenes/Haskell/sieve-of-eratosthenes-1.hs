import Control.Monad (forM_, when)
import Control.Monad.ST
import Data.Array.ST
import Data.Array.Unboxed

sieveUO :: Int -> UArray Int Bool
sieveUO top = runSTUArray $ do
    let m = (top-1) `div` 2
        r = floor . sqrt $ fromIntegral top + 1
    sieve <- newArray (1,m) True          -- :: ST s (STUArray s Int Bool)
    forM_ [1..r `div` 2] $ \i -> do       -- prime(i) = 2i+1
      isPrime <- readArray sieve i        -- ((2i+1)^2-1)`div`2 = 2i(i+1)
      when isPrime $ do
        forM_ [2*i*(i+1), 2*i*(i+2)+1..m] $ \j -> do
          writeArray sieve j False
    return sieve

primesToUO :: Int -> [Int]
primesToUO top | top > 1   = 2 : [2*i + 1 | (i,True) <- assocs $ sieveUO top]
               | otherwise = []
