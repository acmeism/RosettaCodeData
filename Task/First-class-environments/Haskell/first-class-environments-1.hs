hailstone n
  | n == 1 = 1
  | even n = n `div` 2
  | odd n  = 3*n + 1
