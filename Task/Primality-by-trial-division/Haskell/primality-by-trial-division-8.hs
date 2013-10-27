primesT = 2 : 3 : sieve [5,7..] 9 (tail primesT) where
   sieve (x:xs) q ps@(p:t) | x < q     = x : sieve xs q ps
                           | otherwise = sieve [x | x <- xs, x `mod` p /= 0] (head t^2) t
