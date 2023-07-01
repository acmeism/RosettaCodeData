#!/usr/bin/env runghc

import Data.HashSet (HashSet, fromList, member)
import Data.List
import Data.Numbers.Primes
import System.Environment
import System.Exit
import System.IO

-- optimization mentioned on the talk page
startDigOK :: Integer -> Bool
startDigOK n = head (show n) `elem` "1379"

-- infinite list of primes that have an acceptable first digit
filtPrimes :: [Integer]
filtPrimes = filter startDigOK primes

-- finite list of primes that have an acceptable first digit and
-- are the specified number of digits in length
nDigsFPr :: Integer -> [Integer]
nDigsFPr n =
  takeWhile (< hi) $ dropWhile (< lo) filtPrimes
  where lo = 10 ^ (n - 1)
        hi = 10 ^ n

-- hash set of the filtered primes of the specified number of digits
nDigsFPrHS :: Integer -> HashSet Integer
nDigsFPrHS n = fromList $ nDigsFPr n

-- infinite list of hash sets, where each hash set contains primes of
-- a specific number of digits, i. e. index 2 contains 2 digit primes,
-- index 3 contains 3 digit primes, etc.
-- Don't access index 0, because it will return an error
fPrByDigs :: [HashSet Integer]
fPrByDigs = map nDigsFPrHS [0 ..]

isEmirp :: Integer -> Bool
isEmirp n =
  let revStr = reverse $ show n
      reversed = read revStr
      hs = fPrByDigs !! length revStr
  in (startDigOK n) && (reversed /= n) && (reversed `member` hs)

emirps :: [Integer]
emirps = filter isEmirp primes

emirpSlice :: Integer -> Integer -> [Integer]
emirpSlice from to =
  genericTake numToTake $ genericDrop numToDrop emirps
  where
    numToDrop = from - 1
    numToTake = 1 + to - from

emirpValues :: Integer -> Integer -> [Integer]
emirpValues lo hi =
  dropWhile (< lo) $ takeWhile (<= hi) emirps

usage = do
  name <- getProgName
  putStrLn $ "usage: " ++ name ++ " lo hi [slice | values]"
  exitFailure

main = do
  hSetBuffering stdout NoBuffering
  args <- getArgs
  fixedArgs <- case length args of
    1 -> return $ args ++ args ++ ["slice"]
    2 -> return $ args ++ ["slice"]
    3 -> return args
    _ -> usage
  let lo = read $ fixedArgs !! 0
      hi = read $ fixedArgs !! 1
  case fixedArgs !! 2 of
   "slice" -> print $ emirpSlice lo hi
   "values" -> print $ emirpValues lo hi
   _ -> usage
