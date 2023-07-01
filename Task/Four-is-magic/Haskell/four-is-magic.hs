module Main where

import Data.List (find)
import Data.Char (toUpper)

firstNums :: [String]
firstNums =
  [ "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten",
    "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"
  ]

tens :: [String]
tens = ["twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"]

biggerNumbers :: [(Int, String)]
biggerNumbers =
  [(100, "hundred"), (1000, "thousand"), (1000000, "million"), (1000000000, "billion"), (1000000000000, "trillion")]

cardinal :: Int -> String
cardinal n
  | n' < 20 =
    negText ++ firstNums !! n'
  | n' < 100 =
    negText ++ tens !! (n' `div` 10 - 2) ++ if n' `mod` 10 /= 0 then "-" ++ firstNums !! (n' `mod` 10) else ""
  | otherwise =
    let (num, name) =
          maybe
            (last biggerNumbers)
            fst
            (find (\((num_, _), (num_', _)) -> n' < num_') (zip biggerNumbers (tail biggerNumbers)))
        smallerNum = cardinal (n' `div` num)
     in negText ++ smallerNum ++ " " ++ name ++ if n' `mod` num /= 0 then " " ++ cardinal (n' `mod` num) else ""
  where
    n' = abs n
    negText = if n < 0 then "negative " else ""

capitalized :: String -> String
capitalized (x : xs) = toUpper x : xs
capitalized [] = []

magic :: Int -> String
magic =
  go True
  where
    go first num =
      let cardiNum = cardinal num
       in (if first then capitalized else id) cardiNum ++ " is "
            ++ if num == 4
              then "magic."
              else cardinal (length cardiNum) ++ ", " ++ go False (length cardiNum)

main :: IO ()
main = do
  putStrLn $ magic 3
  putStrLn $ magic 15
  putStrLn $ magic 4
  putStrLn $ magic 10
  putStrLn $ magic 20
  putStrLn $ magic (-13)
  putStrLn $ magic 999999
