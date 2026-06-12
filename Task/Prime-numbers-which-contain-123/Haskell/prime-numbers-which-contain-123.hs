import Data.List ( isInfixOf )

isPrime :: Int -> Bool
isPrime n
   |n < 2 = False
   |otherwise = null $ filter (\i -> mod n i == 0 ) [2 .. root]
   where
      root :: Int
      root = floor $ sqrt $ fromIntegral n

condition :: Int -> Bool
condition n = isPrime n && isInfixOf "123" ( show n )

solution :: [Int]
solution = filter condition [2..99999]
