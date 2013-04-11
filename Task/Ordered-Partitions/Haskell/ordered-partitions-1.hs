import Data.List ((\\))

comb :: Int -> [a] -> [[a]]
comb 0 _      = [[]]
comb _ []     = []
comb k (x:xs) = map (x:) (comb (k-1) xs) ++ comb k xs

partitions :: [Int] -> [[[Int]]]
partitions xs = p [1..sum xs] xs
    where p _ []      = [[]]
          p xs (k:ks) = [ cs:rs | cs <- comb k xs, rs <- p (xs \\ cs) ks ]

main = print $ partitions [2,0,2]
