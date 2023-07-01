findRoot f df = fixedPoint (\x -> x - f x / df x)

fixedPoint f x | abs (fx - x) < 1e-15 = x
               | otherwise = fixedPoint f fx
  where fx = f x
