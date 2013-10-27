primes :: [Integer]
primes = 2 : _Y g
  where
    g xs = 3 : gaps 5 (unionAll [[p*p, p*p+2*p..] | p <- xs])

gaps k s@(x:xs) | k < x     = k:gaps (k+2) s      -- [k,k+2..]`minus`s, k<=x
                | otherwise =   gaps (k+2) xs     --  && null(s`minus`[k,k+2..])

unionAll ((x:xs):t) = x : (union xs . unionAll . pairs) t
  where
    pairs ((x:xs):ys:t) = (x : union xs ys) : pairs t
