coeffs = iterate next [1]
  where
    next ns = zipWith (+) (0:ns) $ ns ++ [0]

main = print $ coeffs !! 5 !! 3
