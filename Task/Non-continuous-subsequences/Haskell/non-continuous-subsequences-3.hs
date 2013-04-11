import Data.List

poset = foldr (\x p -> p ++ map (x:) p) [[]]

ncsubs [] = [[]]
ncsubs (x:xs) = tail $ nc [x] xs
  where
    nc [_] [] = [[]]
    nc (_:x:xs) [] = nc [x] xs
    nc  xs (y:ys) = (nc (xs++[y]) ys) ++ map (xs++) (tail $ poset ys)
