import Data.List (delete)

permutations :: Eq a -> [a] -> [[a]]
permutations [] = [[]]
permutations xs = [ x:ys | x <- xs, ys <- permutations (delete x xs)]
