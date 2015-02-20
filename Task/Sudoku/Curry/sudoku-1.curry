-----------------------------------------------------------------------------
--- Solving Su Doku puzzles in Curry with FD constraints
---
--- @author Michael Hanus
--- @version December 2005
-----------------------------------------------------------------------------

import CLPFD
import List

-- Solving a Su Doku puzzle represented as a matrix of numbers (possibly free
-- variables):
sudoku :: [[Int]] -> Success
sudoku m =
 domain (concat m) 1 9 &                         -- define domain of all digits
 foldr1 (&) (map allDifferent m)  &             -- all rows contain different digits
 foldr1 (&) (map allDifferent (transpose m))  & -- all columns have different digits
 foldr1 (&) (map allDifferent (squaresOfNine m)) & -- all 3x3 squares are different
 labeling [FirstFailConstrained] (concat m)

-- translate a matrix into a list of small 3x3 squares
squaresOfNine :: [[a]] -> [[a]]
squaresOfNine [] = []
squaresOfNine (l1:l2:l3:ls) = group3Rows [l1,l2,l3] ++ squaresOfNine ls

group3Rows l123 = if null (head l123) then [] else
 concatMap (take 3) l123 : group3Rows (map (drop 3) l123)

-- read a Su Doku specification written as a list of strings containing digits
-- and spaces
readSudoku :: [String] -> [[Int]]
readSudoku s = map (map transDigit) s
 where
   transDigit c = if c==' ' then x else ord c - ord '0'
      where x free

-- show a solved Su Doku matrix
showSudoku :: [[Int]] -> String
showSudoku = unlines . map (concatMap (\i->[chr (i + ord '0'),' ']))

-- the main function, e.g., evaluate (main s1):
main s | sudoku m = putStrLn (showSudoku m)
 where m = readSudoku s

s1 = ["9  2  5  ",
      " 4  6  3 ",
      "  3     6",
      "   9  2  ",
      "    5  8 ",
      "  7  4  3",
      "7     1  ",
      " 5  2  4 ",
      "  1  6  9"]

s2 = ["819  5   ",
      "  2   75 ",
      " 371 4 6 ",
      "4  59 1  ",
      "7  3 8  2",
      "  3 62  7",
      " 5 7 921 ",
      " 64   9  ",
      "   2  438"]
