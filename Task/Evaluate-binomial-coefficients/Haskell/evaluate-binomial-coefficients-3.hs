choose :: (Integral a) => a -> a -> a
choose n k = foldl (\z i -> (z * (n-i+1)) `div` i) 1 [1..k]
