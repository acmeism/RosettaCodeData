import Data.List ( sort )

isPrime :: Int -> Bool
isPrime n
   |n == 1 = False
   |n == 2 = True
   |otherwise = all (\d -> mod n d /= 0 ) [2..limit]
   where
    limit = floor $ sqrt $ fromIntegral n

solution :: [Int]
solution = sort $ filter isPrime [2 , 43 , 122 , 63, 13 , 7 , 95 , 103]
