primesE  = sieve [2..]
           where
           sieve (p:xs) = p : sieve (minus xs [p, p+p..])
-- unfoldr (\(p:xs)-> Just (p, minus xs [p, p+p..])) [2..]
