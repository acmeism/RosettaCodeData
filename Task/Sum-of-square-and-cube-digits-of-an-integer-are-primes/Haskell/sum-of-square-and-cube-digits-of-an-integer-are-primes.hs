import Data.Bifunctor (first)
import Data.Numbers.Primes (isPrime)

---- SQUARE AND CUBE BOTH HAVE PRIME DECIMAL DIGIT SUMS --

p :: Int -> Bool
p =
  ((&&) . primeDigitSum . (^ 2))
    <*> (primeDigitSum . (^ 3))

--------------------------- TEST -------------------------
main :: IO ()
main = print $ filter p [2 .. 99]

------------------------- GENERIC ------------------------
primeDigitSum :: Int -> Bool
primeDigitSum = isPrime . digitSum 10

digitSum :: Int -> Int -> Int
digitSum base = go
  where
    go 0 = 0
    go n = uncurry (+) . first go $ quotRem n base
