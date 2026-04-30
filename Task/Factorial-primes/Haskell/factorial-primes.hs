isPrime :: Integer -> Bool
isPrime n
  | n < 2 = False
  | n == 2 = True
  | otherwise = 0 == length [i | i <- [2..floor(sqrt (fromIntegral n))], n `mod` i == 0]

data Op = SubtractOne | AddOne
  deriving (Show)

data Prime = Prime
  { fact  :: Integer,
    prime :: Integer,
    op    :: Op
} deriving (Show)

getFactorialPrimes :: Integer -> [Prime]
getFactorialPrimes n
  | isPrime (f - 2) = Prime {fact = n, prime = f - 2, op = SubtractOne} :
    (if isPrime f then [Prime {fact = n, prime = f, op = AddOne}] else [])
  | otherwise = (if isPrime f then [Prime {fact = n, prime = f, op = AddOne}] else [])
  where
    factorial n = product[1..n]
    f = factorial n + 1

factorialPrimes = concat $ map getFactorialPrimes [1..]
main = mapM_ print $ take 10 factorialPrimes
