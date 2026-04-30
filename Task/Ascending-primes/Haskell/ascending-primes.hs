import Data.List (sort, subsequences)

isPrime :: Integer -> Bool
isPrime n
  | n < 2 = False
  | n == 2 = True
  | otherwise = 0 == length [i | i <- [2..floor(sqrt (fromIntegral n))], n `mod` i == 0]

isAscending :: [Integer] -> Bool
isAscending [] = True
isAscending [x] = True
isAscending (x:xs) = (if x >= (head xs) then False else isAscending xs)

getInt :: [Integer] -> Integer
getInt = foldl (\acc x -> acc * 10 + x) 0

ascendingInts = sort [getInt xs | xs <- subsequences([1..9]), 0 < length xs, isAscending xs]
main = print [n | n <- ascendingInts, isPrime n]
