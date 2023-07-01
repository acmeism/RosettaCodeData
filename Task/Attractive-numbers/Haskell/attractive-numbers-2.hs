import Data.Numbers.Primes

attractiveNumbers :: [Integer]
attractiveNumbers =
  [ x
  | x <- [1 ..]
  , isPrime (length (primeFactors x)) ]

main :: IO ()
main = print $ takeWhile (<= 120) attractiveNumbers
