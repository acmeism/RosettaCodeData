import Data.Numbers.Primes (primes)
import Math.NumberTheory.Primes.Testing (isPrime)
import Data.List (nub)

primorials :: [Integer]
primorials = 1 : scanl1 (*) primes

nextPrime :: Integer -> Integer
nextPrime n
  | even n = head $ dropWhile (not . isPrime) [n+1, n+3..]
  | even n = nextPrime (n+1)

fortunateNumbers :: [Integer]
fortunateNumbers = (\p -> nextPrime (p + 2) - p) <$> tail primorials
