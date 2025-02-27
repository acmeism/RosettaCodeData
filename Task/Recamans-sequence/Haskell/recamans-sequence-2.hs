recaman :: Integer -> [Integer]
recaman n = reverse (go 0 0 [])
            where
                go i a_n xs | i > n    = xs
                            | (am > 0) && (not (any (am ==) xs)) = go (i + 1) am (am : xs)
                            | otherwise = go (i + 1) ap (ap : xs)
                            where  am =  a_n - (i + 1)
                                   ap =  a_n + (i + 1)
