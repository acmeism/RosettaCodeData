factorize n = [ d | p <- [2..n], isPrime p, d <- divs n p ]
           -- [2..n] >>= (\p-> [p|isPrime p]) >>= divs n
    where
    divs n p | rem n p == 0 = p : divs (quot n p) p
             | otherwise    = []
