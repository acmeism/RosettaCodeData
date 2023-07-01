import Data.List

 mmult :: Num a => [[a]] -> [[a]] -> [[a]]
 mmult a b = [ [ sum $ zipWith (*) ar bc | bc <- (transpose b) ] | ar <- a ]

 -- Example use:
 test = [[1, 2],
         [3, 4]] `mmult` [[-3, -8, 3],
                          [-2,  1, 4]]
