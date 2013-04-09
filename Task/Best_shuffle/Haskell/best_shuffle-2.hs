bestShuffle :: Eq a => [a] -> [a]
bestShuffle s = minimumBy (compare `on` score s) $ permutations s
