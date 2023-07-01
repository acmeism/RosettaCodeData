primesTo m = sieve [2..m]
   where
   sieve (p:xs) | p*p > m   = p : xs
                | otherwise = p : sieve [x | x <- xs, rem x p /= 0]
-- (\(a,b:_) -> map head a ++ b) . span ((< m).(^2).head)
--   $ iterate (\(p:xs) -> filter ((>0).(`rem`p)) xs) [2..m]
