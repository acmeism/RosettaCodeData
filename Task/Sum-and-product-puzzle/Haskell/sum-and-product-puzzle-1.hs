import Data.List (intersect)

s1, s2, s3, s4 :: [(Int, Int)]
s1 = [(x, y) | x <- [1 .. 100], y <- [1 .. 100], 1 < x && x < y && x + y < 100]

add, mul :: (Int, Int) -> Int
add (x, y) = x + y
mul (x, y) = x * y

sumEq, mulEq :: (Int, Int) -> [(Int, Int)]
sumEq p = filter (\q -> add q == add p) s1
mulEq p = filter (\q -> mul q == mul p) s1

s2 = filter (\p -> all (\q -> (length $ mulEq q) /= 1) (sumEq p)) s1
s3 = filter (\p -> length (mulEq p `intersect` s2) == 1) s2
s4 = filter (\p -> length (sumEq p `intersect` s3) == 1) s3

main = print s4
