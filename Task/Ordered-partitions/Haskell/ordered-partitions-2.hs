comb :: Int -> [a] -> [([a],[a])]
comb 0 xs     = [([],xs)]
comb _ []     = []
comb k (x:xs) = [ (x:cs,zs) | (cs,zs) <- comb (k-1) xs ] ++
                [ (cs,x:zs) | (cs,zs) <- comb  k    xs ]

partitions :: [Int] -> [[[Int]]]
partitions xs = p [1..sum xs] xs
    where p _ []      = [[]]
          p xs (k:ks) = [ cs:rs | (cs,zs) <- comb k xs, rs <- p zs ks ]

main = print $ partitions [2,0,2]
