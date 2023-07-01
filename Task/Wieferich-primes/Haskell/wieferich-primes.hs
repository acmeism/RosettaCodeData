isPrime :: Integer -> Bool
isPrime n
   |n == 2 = True
   |n == 1 = False
   |otherwise = null $ filter (\i -> mod n i == 0 ) [2 .. root]
   where
      root :: Integer
      root = toInteger $ floor $ sqrt $ fromIntegral n

isWieferichPrime :: Integer -> Bool
isWieferichPrime n =  isPrime n && mod ( 2 ^ ( n - 1 ) - 1 ) ( n ^ 2 ) == 0

solution :: [Integer]
solution = filter isWieferichPrime [2 .. 5000]

main :: IO ( )
main = do
   putStrLn "Wieferich primes less than 5000:"
   print solution
