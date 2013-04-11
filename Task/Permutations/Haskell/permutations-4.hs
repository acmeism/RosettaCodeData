permutations :: [a] -> [[a]]
permutations = foldr (concatMap . insertEverywhere) [[]]
  where insertEverywhere :: a -> [a] -> [[a]]
        insertEverywhere x [] = [[x]]
        insertEverywhere x l@(y:ys) = (x:l) : map (y:) (insertEverywhere x ys)
