primes :: [Int]
primes = 2 : _Y ( (3:) . gaps 5 . _U . map(\p-> [p*p, p*p+2*p..]) )

gaps k s@(c:cs) | k < c     = k : gaps (k+2) s        -- ~= ([k,k+2..] \\ s)
                | otherwise =     gaps (k+2) cs       --   when null(s\\[k,k+2..])

_U ((x:xs):t) = x : (union xs . _U . pairs) t         -- ~= nub . sort . concat
  where
    pairs (xs:ys:t) = union xs ys : pairs t
