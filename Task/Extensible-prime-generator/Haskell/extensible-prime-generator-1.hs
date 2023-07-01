#!/usr/bin/env runghc

import Data.List
import Data.Numbers.Primes
import System.IO

firstNPrimes :: Integer -> [Integer]
firstNPrimes n = genericTake n primes

primesBetweenInclusive :: Integer -> Integer -> [Integer]
primesBetweenInclusive lo hi =
  dropWhile (< lo) $ takeWhile (<= hi) primes

nthPrime :: Integer -> Integer
nthPrime n = genericIndex primes (n - 1) -- beware 0-based indexing

main = do
  hSetBuffering stdout NoBuffering
  putStr "First 20 primes: "
  print $ firstNPrimes 20
  putStr "Primes between 100 and 150: "
  print $ primesBetweenInclusive 100 150
  putStr "Number of primes between 7700 and 8000: "
  print $ genericLength $ primesBetweenInclusive 7700 8000
  putStr "The 10000th prime: "
  print $ nthPrime 10000
