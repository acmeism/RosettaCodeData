powerMod
  :: (Integral a, Integral b)
  => a -> a -> b -> a
powerMod m _ 0 = 1
powerMod m x n
  | n > 0 = f x_ (n - 1) x_
  where
    x_ = x `rem` m
    f _ 0 y = y
    f a d y = g a d
      where
        g b i
          | even i = g (b * b `rem` m) (i `quot` 2)
          | otherwise = f b (i - 1) (b * y `rem` m)
powerMod m _ _ = error "powerMod: negative exponent"
