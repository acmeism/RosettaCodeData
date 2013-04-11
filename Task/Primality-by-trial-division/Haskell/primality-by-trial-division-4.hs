primes = sieve [2..] where
   sieve (p:xs) = p : sieve [x | x <- xs, rem x p /= 0]
