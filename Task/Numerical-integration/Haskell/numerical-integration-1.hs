approx f xs ws = sum [w * f x | (x,w) <- zip xs ws]
