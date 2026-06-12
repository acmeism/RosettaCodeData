import Data.List.Split ( divvy )

isPrime :: Int -> Bool
isPrime n
   |n == 2 = True
   |n == 1 = False
   |otherwise = null $ filter (\i -> mod n i == 0 ) [2 .. root]
   where
      root :: Int
      root = floor $ sqrt $ fromIntegral n

solution :: Int
solution = maximum $ map (\li -> last li - head li ) $ divvy 2 1 $ filter
 isPrime [1..999999]

main :: IO ( )
main = do
   print solution
