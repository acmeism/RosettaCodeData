co9 n
  | n <= 8 = n
  | otherwise = co9 $ sum $ filter (/= 9) $ digits 10 n

task2 = filter (\n -> co9 n == co9 (n ^ 2)) [1 .. 100]

task3 k = filter (\n -> n `mod` k == n ^ 2 `mod` k) [1 .. 100]
