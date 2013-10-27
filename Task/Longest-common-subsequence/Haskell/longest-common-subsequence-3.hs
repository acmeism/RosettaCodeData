import Data.Array

lcs xs ys = a!(0,0) where
  n = length xs
  m = length ys
  a = array ((0,0),(n,m)) $ l1 ++ l2 ++ l3
  l1 = [((i,m),[]) | i <- [0..n]]
  l2 = [((n,j),[]) | j <- [0..m]]
  l3 = [((i,j), f x y i j) | (x,i) <- zip xs [0..], (y,j) <- zip ys [0..]]
  f x y i j
    | x == y    = x : a!(i+1,j+1)
    | otherwise = longest (a!(i,j+1)) (a!(i+1,j))
