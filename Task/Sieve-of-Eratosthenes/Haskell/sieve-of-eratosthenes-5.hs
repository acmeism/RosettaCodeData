primesE  = sieve [2..]
           where
           sieve (p:xs) = p : sieve (minus xs [p, p+p..])
