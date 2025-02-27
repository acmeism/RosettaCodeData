factorial :: Integral -> Integral
factorial 0 = 1
factorial n = n * factorial (n-1)
