import Data.List.Split ( divvy )

isPrime :: Int -> Bool
isPrime n
   |n < 2 = False
   |otherwise = null $ filter (\i -> mod n i == 0 ) [2 .. root]
   where
      root :: Int
      root = floor $ sqrt $ fromIntegral n

solution :: [Int]
solution = map head $ filter (\li -> isPrime ((head li * last li) + 2 ))
 $ divvy 2 1 $ filter isPrime [2..upTo]
 where
  upTo :: Int
  upTo = head $ take 1 $ filter isPrime [500..]
