mean :: (Fractional a) => [a] -> a
mean [] = 0
mean xs = sum xs / Data.List.genericLength xs
