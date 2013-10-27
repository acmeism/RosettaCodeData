import Test.HUnit
import Data.List

factor::Int->[Int]
factor 1 = []
factor n
  | product primeDivisor == n = primeDivisor
  | otherwise = primeDivisor ++ factor (div n $ product primeDivisor)
  where
    primeDivisor = filter isPrime $ filter (isDivisor n) [2 .. n]
    isDivisor n d = (==) 0 $ mod n d
    isPrime n = not $ any (isDivisor n) [2 .. n-1]

tests = TestList[TestCase $ assertEqual "1 has no prime factors" [] $ factor 1
                ,TestCase $ assertEqual "2 is 2" [2] $ factor 2
                ,TestCase $ assertEqual "3 is 3" [3] $ factor 3
                ,TestCase $ assertEqual "4 is 2*2" [2, 2] $ factor 4
                ,TestCase $ assertEqual "5 is 5" [5] $ factor 5
                ,TestCase $ assertEqual "6 is 2*3" [2, 3] $ factor 6
                ,TestCase $ assertEqual "7 is 7" [7] $ factor 7
                ,TestCase $ assertEqual "8 is 2*2*2" [2, 2, 2] $ factor 8
                ,TestCase $ assertEqual "large number" [2, 3, 3, 5, 7, 11, 13] $ sort $ factor (2*9*5*7*11*13)]
