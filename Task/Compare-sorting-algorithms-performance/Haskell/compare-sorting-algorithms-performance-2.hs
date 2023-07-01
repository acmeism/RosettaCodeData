-- Naive quick sort
qsort :: Ord a => Sorter a
qsort [] = []
qsort (h:t) = qsort (filter (< h) t) ++ [h] ++ qsort (filter (>= h) t)

-- Bubble sort
bsort :: Ord a => Sorter a
bsort s = case _bsort s of
               t | t == s    -> t
                 | otherwise -> bsort t
  where _bsort (x:x2:xs) | x > x2    = x2:_bsort (x:xs)
                         | otherwise = x :_bsort (x2:xs)
        _bsort s = s

-- Insertion sort
isort :: Ord a => Sorter a
isort = foldr insert []
