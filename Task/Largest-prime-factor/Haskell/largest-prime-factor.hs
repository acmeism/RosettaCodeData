isPrime :: Integer -> Bool
isPrime n
  | n < 2 = False
  | n == 2 = True
  | otherwise = 0 == length [i | i <- [2..floor(sqrt (fromIntegral n))], n `mod` i == 0]

largestPrimeFactor :: Integer -> Integer
largestPrimeFactor n
  | n < 2 = 1
  | otherwise = max smallestPrime (largestPrimeFactor(n `div` smallestPrime))
  where
    setOfAllPrimes = [i | i <- [2..], isPrime i]
    isNotDivisible x y = 0 /= x `mod` y
    smallestPrime = head (dropWhile (isNotDivisible n) setOfAllPrimes)

x = 600851475143
main = print(largestPrimeFactor x)
