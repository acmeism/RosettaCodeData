primesPT = 2 : 3 : sieve [5,7..] 9 (tail primesPT)
   where
   sieve (x:xs) q ps@(p:t)
        | x < q     = x : sieve xs q ps    -- inlined (span (< q))
        | otherwise = sieve [y | y <- xs, rem y p /= 0] (head t^2) t
-- fix $ (2:) . concatMap (fst.snd)
--   . iterate (\(p:t,(h,xs)) -> (t,span (< head t^2) [y | y <- xs, rem y p /= 0]))
--   . (, ([3],[4..]))
