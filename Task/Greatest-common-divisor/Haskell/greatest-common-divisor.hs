gcd :: (Integral a) => a -> a -> a
gcd x y = gcd_ (abs x) (abs y)
  where
    gcd_ a 0 = a
    gcd_ a b = gcd_ b (a `rem` b)
