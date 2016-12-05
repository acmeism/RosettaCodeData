factorize n = divs n primesList
     where
     divs n ds@(d:t) | d*d > n    = [n | n > 1]
                     | r == 0     =  d : divs q ds
                     | otherwise  =      divs n t
            where  (q,r) = quotRem n d
