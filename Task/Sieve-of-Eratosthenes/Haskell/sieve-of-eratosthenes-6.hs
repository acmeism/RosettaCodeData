primesEQ = after 4 [2..] (sieve primesEQ) -- faster, ~ n^1.5
   where     -- q==p*p
   sieve (p:t) q xs = after (head t^2) (minus xs [q,q+p..]) (sieve t)

after q (x:xs) k | x < q     = x : after q xs k
                 | otherwise = k x xs
