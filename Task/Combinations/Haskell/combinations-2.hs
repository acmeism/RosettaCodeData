import Data.List (tails)

comb :: Int -> [a] -> [[a]]
comb 0 _      = [[]]
comb m l = [x:ys | x:xs <- tails l, ys <- comb (m-1) xs]
