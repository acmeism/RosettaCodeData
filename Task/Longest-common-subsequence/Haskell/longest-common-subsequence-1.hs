longest xs ys = if length xs > length ys then xs else ys

lcs [] _ = []
lcs _ [] = []
lcs (x:xs) (y:ys)
  | x == y    = x : lcs xs ys
  | otherwise = longest (lcs (x:xs) ys) (lcs xs (y:ys))
