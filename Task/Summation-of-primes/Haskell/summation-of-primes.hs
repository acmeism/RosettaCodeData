import Data.Numbers.Primes (primes)

sumOfPrimesBelow :: Integral a => a -> a
sumOfPrimesBelow n =
  sum $ takeWhile (< n) primes

main :: IO ()
main = print $ sumOfPrimesBelow 2000000
