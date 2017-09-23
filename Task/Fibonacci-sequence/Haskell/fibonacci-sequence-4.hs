fib n = go n 0 1
  where
    go n a b
      | n == 0 = a
      | otherwise = go (n - 1) b (a + b)
