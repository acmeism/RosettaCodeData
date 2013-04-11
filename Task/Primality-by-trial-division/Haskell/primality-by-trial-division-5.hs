primesTo m = 2 : sieve [3,5..m] where
   sieve (p:xs) | p*p > m   = p : xs
                | otherwise = p : sieve [x | x <- xs, rem x p /= 0]
