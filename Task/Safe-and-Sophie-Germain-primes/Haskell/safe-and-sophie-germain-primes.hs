isPrime :: Int -> Bool
isPrime n
   |n == 2 = True
   |otherwise = all (\i -> mod n i /= 0 ) [2..limit]
    where
     limit = floor $ sqrt $ fromIntegral n

solution :: [Int]
solution = take 50 $ filter (\i -> isPrime i && isPrime ( 2 * i + 1 ) ) [2 , 3 ..]
