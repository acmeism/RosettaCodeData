integrateClosed :: Fractional a => a -> [a] -> (a -> a) -> a -> a -> Int -> a
integrateClosed v vs f a b n = approx f xs ws * h / v where
  m = fromIntegral (length vs - 1) * n
  h = (b-a) / fromIntegral m
  ws = overlap n vs
  xs = [a + h * fromIntegral i | i <- [0..m]]

overlap :: Num a => Int -> [a] -> [a]
overlap n []  = []
overlap n (x:xs) = x : inter n xs where
  inter 1 ys     = ys
  inter n []     = x : inter (n-1) xs
  inter n [y]    = (x+y) : inter (n-1) xs
  inter n (y:ys) = y : inter n ys
