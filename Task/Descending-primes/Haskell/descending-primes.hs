import Data.List (sort, subsequences)

isPrime :: Integer -> Bool
isPrime n
  | n < 2 = False
  | n == 2 = True
  | otherwise = 0 == length [i | i <- [2..floor(sqrt (fromIntegral n))], n `mod` i == 0]

isDescending :: [Integer] -> Bool
isDescending [] = True
isDescending [x] = True
isDescending (x:xs) = (if x <= (head xs) then False else isDescending xs)

getInt :: [Integer] -> Integer
getInt = foldl (\acc x -> acc * 10 + x) 0

descendingInts = sort [getInt xs | xs <- subsequences([9,8..1]), 0 < length xs, isDescending xs]
main = print [n | n <- descendingInts, isPrime n]
