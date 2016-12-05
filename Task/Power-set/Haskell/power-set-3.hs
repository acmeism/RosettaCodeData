powerSet :: [a] -> [[a]]
powerset = foldr (\x acc -> acc ++ map (x:) acc) [[]]
