primesPE = 2 : sieve [3..] 4 primesPE
               where
               sieve (x:xs) q (p:t)
                 | x < q     = x : sieve xs q (p:t)
                 | otherwise =     sieve (minus xs [q, q+p..]) (head t^2) t
