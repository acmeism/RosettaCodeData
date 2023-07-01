primesPT = sieve primesPT [2..]
           where
           sieve ~(p:ps) (x:xs) = x : after (p*p) xs
                                        (sieve ps . filter ((> 0).(`rem` p)))
           after q (x:xs) f | x < q = x : after q xs f
                            | otherwise = f (x:xs)
-- fix $ concatMap (fst.fst) . iterate (\((_,t),p:ps) ->
--         (span (< head ps^2) [x | x <- t, rem x p > 0], ps)) . (,) ([2,3],[4..])
