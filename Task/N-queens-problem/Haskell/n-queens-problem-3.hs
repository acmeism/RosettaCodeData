import Data.List (nub, permutations)

-- checks if queens are on the same diagonal
-- with [0..] we place each queen on her own row
check f = length . nub . zipWith f [0..]

-- filters out results where 2 or more queens are on the same diagonal
-- with [0..n-1] we place each queeen on her own column
generate n = filter (\x -> check (+) x == n && check (-) x == n) $ permutations [0..n-1]

-- 8 is for "8 queens"
main = print $ generate 8
