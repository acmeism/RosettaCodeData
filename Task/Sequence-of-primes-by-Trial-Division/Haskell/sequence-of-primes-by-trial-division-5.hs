primesTo m = 2 : sieve [3,5..m]
   where
   sieve (p:xs) | p*p > m   = p : xs
                | otherwise = p : sieve [x | x <- xs, rem x p /= 0]
-- map fst a ++ b:c where (a,(b,c):_) = span ((< m).(^2).fst)
--  . iterate (\(_,p:xs)-> (p, [x | x <- xs, rem x p /= 0])) $ (2, [3,5..m])
