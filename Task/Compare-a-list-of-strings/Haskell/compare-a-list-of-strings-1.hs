allEqual :: Eq a => [a] -> Bool
allEqual xs = and $ zipWith (==) xs (tail xs)

allIncr :: Ord a => [a] -> Bool
allIncr xs = and $ zipWith (<) xs (tail xs)
