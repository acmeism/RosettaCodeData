factorize n | n > 1 = go n primesList
   where
     go n ds@(d:t)
        | d*d > n    = [n]
        | r == 0     =  d : go q ds
        | otherwise =      go n t
            where
              (q,r) = quotRem n d
