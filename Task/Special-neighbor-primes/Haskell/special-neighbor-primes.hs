import Data.List.Split ( divvy )

isPrime :: Int -> Bool
isPrime n
   |n == 2 = True
   |otherwise = all (\i -> mod n i /= 0 ) [2..limit]
   where
    limit = floor $ sqrt $ fromIntegral n

solution :: [[Int]]
solution = filter (\subli -> isPrime (head subli + last subli - 1 )) $ divvy 2 1
 $ filter isPrime [2..99]
