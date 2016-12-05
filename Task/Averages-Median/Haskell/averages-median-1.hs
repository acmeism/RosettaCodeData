nth (x:xs) n
    | k == n    = x
    | k > n     = nth ys n
    | otherwise = nth zs $ n - k - 1
    where (ys, zs) = partition (< x) xs
          k = length ys

median xs | even n = (nth xs (div n 2) + nth xs (div n 2 - 1)) / 2.0
          | otherwise = nth xs (div n 2)
  where
     n = length xs
