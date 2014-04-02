perfect n =
    n == sum [i | i <- [1..n-1], n `mod` i == 0]
