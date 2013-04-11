primes :: [Integer]          --  unbounded merging idea due to Richard Bird
primes = 2 : g (fix g)      --  double staged production idea due to Melissa O'Neill
  where                    --  tree merging idea Dave Bayer / simplified formulation Will Ness
    g xs = 3 : gaps 5 (unionAll [[p*p, p*p+2*p..] | p <- xs])

fix g = xs where xs = g xs      -- global definition to prevent space leak

gaps k s@(x:xs) | k < x     = k:gaps (k+2) s      -- [k,k+2..]`minus`s, k<=x !
                | otherwise =   gaps (k+2) xs

unionAll ((x:xs):t) = x : union xs (unionAll (pairs t))
  where
    pairs ((x:xs):ys:t) = (x : union xs ys) : pairs t

union a@(x:xs) b@(y:ys) = case compare x y of
         LT -> x : union  xs b
         EQ -> x : union  xs ys
         GT -> y : union  a  ys
