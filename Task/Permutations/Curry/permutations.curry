insert :: a -> [a] -> [a]
insert x xs  = x : xs
insert x (y:ys) = y : insert x ys

permutation :: [a] -> [a]
permutation []     = []
permutation (x:xs) = insert x $ permutation xs
