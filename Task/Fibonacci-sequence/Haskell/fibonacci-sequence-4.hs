fib :: Integer -> Integer
fib n = fst $ foldl (\(a, b) _ -> (b, a + b)) (0, 1) [1 .. n]
