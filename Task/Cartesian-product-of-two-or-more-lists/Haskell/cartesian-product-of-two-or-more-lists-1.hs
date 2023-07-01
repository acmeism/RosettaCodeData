cartProd :: [a] -> [b] -> [(a, b)]
cartProd xs ys =
  [ (x, y)
  | x <- xs
  , y <- ys ]
