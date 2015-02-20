primesPT = 2 : 3 : sieve [5,7..] 9 (tail primesPT)
   where
   sieve (x:xs) q ps@(p:t)
        | x < q     = x : sieve xs q ps    -- inlined (span (< q))
        | otherwise = sieve [y | y <- xs, rem y p /= 0] (head t^2) t
-- ps = concat . map fst
--      . iterate (\(_,(ns,p:t))-> let (h,xs)=span (< p*p) ns in
--        (h, ([y | y <- xs, rem y p /= 0], t))) $ ([2,3], ([5,7..], tail ps))
