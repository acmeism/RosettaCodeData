selSort :: (Ord a) => [a] -> [a]
selSort [] = []
selSort xs = let x = maximum xs in selSort (remove x xs) ++ [x]
  where remove _ [] = []
        remove a (x:xs)
          | x == a = xs
          | otherwise = x : remove a xs
