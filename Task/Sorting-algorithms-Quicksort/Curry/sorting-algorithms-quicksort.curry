-- quicksort using higher-order functions:

qsort :: [Int] -> [Int]
qsort []     = []
qsort (x:l)  = qsort (filter (<x) l) ++ x : qsort (filter (>=x) l)

goal = qsort [2,3,1,0]
