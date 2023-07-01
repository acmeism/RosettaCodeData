zapWith :: (a -> a -> a) -> [a] -> [a] -> [a]
zapWith f xs [] = xs
zapWith f [] ys = ys
zapWith f (x:xs) (y:ys) = f x y : zapWith f xs ys
