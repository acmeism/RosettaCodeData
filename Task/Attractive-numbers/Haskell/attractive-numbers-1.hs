import Data.Numbers.Primes
import Data.Bool (bool)

attractiveNumbers :: [Integer]
attractiveNumbers =
  [1 ..] >>= (bool [] . return) <*> (isPrime . length . primeFactors)

main :: IO ()
main = print $ takeWhile (<= 120) attractiveNumbers
