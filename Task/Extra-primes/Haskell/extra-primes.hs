import Data.Char ( digitToInt )

isPrime :: Int -> Bool
isPrime n
   |n < 2 = False
   |otherwise = null $ filter (\i -> mod n i == 0 ) [2 .. root]
   where
      root :: Int
      root = floor $ sqrt $ fromIntegral n

condition :: Int -> Bool
condition n = isPrime n && all isPrime digits && isPrime ( sum digits )
 where
  digits :: [Int]
  digits = map digitToInt ( show n )

solution :: [Int]
solution = filter condition [1..9999]
