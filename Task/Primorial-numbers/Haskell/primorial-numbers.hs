import Control.Arrow ((&&&))
import Data.List (scanl1, foldl1')

getNthPrimorial :: Int -> Integer
getNthPrimorial n = foldl1' (*) (take n primes)

primes :: [Integer]
primes = 2 : filter isPrime [3,5..]

isPrime :: Integer -> Bool
isPrime = isPrime_ primes
  where isPrime_ :: [Integer] -> Integer -> Bool
        isPrime_ (p:ps) n
          | p * p > n      = True
          | n `mod` p == 0 = False
          | otherwise      = isPrime_ ps n

primorials :: [Integer]
primorials = 1 : scanl1 (*) primes

main :: IO ()
main = do
  -- Print the first 10 primorial numbers
  let firstTen = take 10 primorials
  putStrLn $ "The first 10 primorial numbers are: " ++ show firstTen

  -- Show the length of the primorials with index 10^[1..6]
  let powersOfTen = [1..6]
      primorialTens = map (id &&& (length . show . getNthPrimorial . (10^))) powersOfTen
      calculate = mapM_ (\(a,b) -> putStrLn $ "Primorial(10^"++show a++") has "++show b++" digits")
  calculate primorialTens
