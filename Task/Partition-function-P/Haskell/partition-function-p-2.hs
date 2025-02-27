part = 1 : b 1
  where b n = p where p = zipWith (+) (1 : b (n + 1)) (replicate n 0 ++ p)
