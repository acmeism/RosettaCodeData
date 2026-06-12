module Squares
   where

isPrime :: Int -> Bool
isPrime n
   |n == 2 = True
   |n == 1 = False
   |otherwise = null $ filter (\i -> mod n i == 0 ) [2 .. root]
   where
      root :: Int
      root = floor $ sqrt $ fromIntegral n

isSquare :: Int -> Bool
isSquare n = theFloor * theFloor == n
 where
  theFloor :: Int
  theFloor = floor $ sqrt $ fromIntegral n

solution :: [Int]
solution = [d | d <- [1..999] , isSquare d && isPrime ( d + 1 )]
