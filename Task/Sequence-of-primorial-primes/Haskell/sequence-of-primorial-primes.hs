import Data.List (scanl1, elemIndices, nub)

primes :: [Integer]
primes = 2 : filter isPrime [3,5 ..]

isPrime :: Integer -> Bool
isPrime = isPrime_ primes
  where
    isPrime_ :: [Integer] -> Integer -> Bool
    isPrime_ (p:ps) n
      | p * p > n = True
      | n `mod` p == 0 = False
      | otherwise = isPrime_ ps n

primorials :: [Integer]
primorials = 1 : scanl1 (*) primes

primorialsPlusMinusOne :: [Integer]
primorialsPlusMinusOne = concatMap (((:) . pred) <*> (return . succ)) primorials

sequenceOfPrimorialPrimes :: [Int]
sequenceOfPrimorialPrimes = (tail . nub) $ (`div` 2) <$> elemIndices True bools
  where
    bools = isPrime <$> primorialsPlusMinusOne

main :: IO ()
main = mapM_ print $ take 10 sequenceOfPrimorialPrimes
