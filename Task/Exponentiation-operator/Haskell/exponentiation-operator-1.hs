(^) :: (Num a, Integral b) => a -> b -> a
_ ^ 0           =  1
x ^ n | n > 0   =  f x (n-1) x where
  f _ 0 y = y
  f a d y = g a d  where
    g b i | even i  = g (b*b) (i `quot` 2)
          | otherwise = f b (i-1) (b*y)
_ ^ _           = error "Prelude.^: negative exponent"
