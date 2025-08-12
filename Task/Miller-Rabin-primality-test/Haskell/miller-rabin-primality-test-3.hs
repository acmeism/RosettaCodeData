mrt 2 = True
mrt x = odd x && all (\a -> work s x (expMod a d x) ) [2..(x-2)] where
  (s,d) = sd (x-1)

sd n = if odd n then (0,n) else (\(x,y) -> (x+1,y)) (sd (n `div` 2))
work 0 n x = (x == 1) || (x == n-1)
work s n x
  |(f == 1) && (x /= 1) && (x /= n-1) = False
  |otherwise = work (s-1) n f  where f = (x*x) `mod` n


expMod a 0 m = 1
expMod a d m
  | even d    = expMod ((a * a) `mod` m) (d `div` 2) m
  | otherwise = (a * expMod a (d - 1) m) `mod` m
