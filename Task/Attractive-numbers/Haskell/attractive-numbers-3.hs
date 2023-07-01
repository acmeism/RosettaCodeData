import Data.Numbers.Primes

attractiveNumbers :: [Integer]
attractiveNumbers =
  filter
    (isPrime . length . primeFactors)
    [1 ..]

main :: IO ()
main = print $ takeWhile (<= 120) attractiveNumbers
