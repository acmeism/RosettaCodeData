import Data.List

qsort [] = []
qsort (x:xs) = qsort ys ++ x : qsort zs where (ys, zs) = partition (< x) xs
