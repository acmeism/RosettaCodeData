module Pernicious
   where

isPernicious :: Integer -> Bool
isPernicious num = isPrime $ toInteger $ length $ filter ( == 1 ) $ toBinary num

isPrime :: Integer -> Bool
isPrime number = divisors number == [1, number]
   where
      divisors :: Integer -> [Integer]
      divisors number = [ m | m <- [1 .. number] , number `mod` m == 0 ]

toBinary :: Integer -> [Integer]
toBinary num = reverse $ map ( `mod` 2 ) ( takeWhile ( /= 0 ) $ iterate ( `div` 2 ) num )

solution1 = take 25 $ filter isPernicious [1 ..]
solution2 = filter isPernicious [888888877 .. 888888888]
