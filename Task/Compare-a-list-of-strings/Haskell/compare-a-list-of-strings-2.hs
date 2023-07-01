allEqual
  :: Eq a
  => [a] -> Bool
allEqual [] = True
allEqual (h:t) = foldl (\a x -> a && x == h) True t

allIncreasing
  :: Ord a
  => [a] -> Bool
allIncreasing [] = True
allIncreasing (h:t) = fst $ foldl (\(a, x) y -> (a && x < y, y)) (True, h) t
