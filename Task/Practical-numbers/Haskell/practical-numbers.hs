check :: [Int] -> Int -> Bool
check [] a = a == 0
check lis@(x:xs) a
    |a<0        = False
    |a == 0     = True
    |otherwise  = check xs (a - x) || check xs a


divisors :: Int -> [Int]
divisors n = [x | x <- [1..n], n `mod` x == 0]

isPrac :: Int -> Bool
isPrac n = if n < 1 then False else all (check (divisors n)) [1..(n-1)]


practicalNumbers :: Int -> [Int]
practicalNumbers x = filter isPrac [1..x]

countPrac :: Int -> Int
countPrac = length . practicalNumbers
