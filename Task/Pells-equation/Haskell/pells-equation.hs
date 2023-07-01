pell :: Integer -> (Integer, Integer)
pell n = go (x, 1, x * 2, 1, 0, 0, 1)
  where
    x = floor $ sqrt $ fromIntegral n
    go (y, z, r, e1, e2, f1, f2) =
      let y' = r * z - y
          z' = (n - y' * y') `div` z
          r' = (x + y') `div` z'
          (e1', e2') = (e2, e2 * r' + e1)
          (f1', f2') = (f2, f2 * r' + f1)
          (a, b) = (f2', e2')
          (b', a') = (a, a * x + b)
      in if a' * a' - n * b' * b' == 1
         then (a', b')
         else go (y', z', r', e1', e2', f1', f2')
