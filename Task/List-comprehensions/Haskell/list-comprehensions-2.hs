pyth :: Int -> [(Int, Int, Int)]
pyth n = do
  x <- [1 .. n]
  y <- [x .. n]
  z <- [y .. n]
  if x ^ 2 + y ^ 2 == z ^ 2
  then [(x, y, z)]
  else []
