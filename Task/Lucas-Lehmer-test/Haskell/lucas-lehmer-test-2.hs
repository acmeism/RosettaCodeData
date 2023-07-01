sieve (p:xs) = p : sieve [x | x <- xs, x `mod` p > 0]
