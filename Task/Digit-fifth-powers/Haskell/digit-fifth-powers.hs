-- Function to calculate the sum of the fifth powers of the digits of a number
sumOfFifthPowers :: Int -> Int
sumOfFifthPowers n = sum [digit^5 | digit <- digits n]

-- Helper function to convert a number into a list of its digits
digits :: Int -> [Int]
digits = map (read . (:[])) . show

-- Main function to compute the sum of all numbers that satisfy the condition
main :: IO ()
main = print $ sum [n | n <- [2..6 * 9^5], sumOfFifthPowers n == n]


