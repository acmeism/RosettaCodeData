import Control.Monad
import Data.List

-- given n, "queens n" solves the n-queens problem, returning a list of all the
-- safe arrangements. each solution is a list of the columns where the queens are
-- located for each row
queens :: Int -> [[Int]]
queens n = map fst $ foldM oneMoreQueen ([],[1..n]) [1..n]  where

  -- foldM :: (Monad m) => (a -> b -> m a) -> a -> [b] -> m a
  -- foldM folds (from left to right) in the list monad, which is convenient for
  -- "nondeterminstically" finding "all possible solutions" of something. the
  -- initial value [] corresponds to the only safe arrangement of queens in 0 rows

  -- given a safe arrangement y of queens in the first i rows, and a list of
  -- possible choices, "oneMoreQueen y _" returns a list of all the safe
  -- arrangements of queens in the first (i+1) rows along with remaining choices
  oneMoreQueen (y,d) _ = [ (x:y, d\\[x]) | x <- d, safe x y 1]

-- "safe x y n" tests whether a queen at column x is safe from previous
-- queens as recorded in y, at the distance n rows away
safe x [] n = True
safe x (c:y) n = and [ x /= c , x /= c + n , x /= c - n , safe x y (n+1)]

-- prints what the board looks like for a solution; with an extra newline
printSolution y = let n = length y in
  do mapM_ (\x -> putStrLn [if z == x then 'Q' else '.' | z <- [1..n]]) y
     putStrLn ""

-- prints all the solutions for 6 queens
main = mapM_ printSolution $ queens 6
