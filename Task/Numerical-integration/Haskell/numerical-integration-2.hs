integrateOpen :: Fractional a => a -> [a] -> (a -> a) -> a -> a -> Int -> a
integrateOpen v vs f a b n = approx f xs ws * h / v where
  m = fromIntegral (length vs) * n
  h = (b-a) / fromIntegral m
  ws = concat $ replicate n vs
  c = a + h/2
  xs = [c + h * fromIntegral i | i <- [0..m-1]]
