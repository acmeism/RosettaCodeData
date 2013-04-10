nth (x:xs) n
    | k == n    = x
    | k > n     = nth ys n
    | otherwise = nth zs $ n - k - 1
    where (ys, zs) = partition (<x) xs
          k = length ys

median xs = nth xs $ length xs `div` 2
