powerSet :: [a] -> [[a]]
powerSet = foldr (\x acc -> acc ++ map (x:) acc) [[]]
