primes :: () -> [Int]
primes() = 2 : _Y ((3:) . gaps 5 . _U . map(\p-> [p*p, p*p+2*p..])) where
  _Y g = g (_Y g)  -- = g (g (g ( ... )))   non-sharing multistage fixpoint combinator
  gaps k s@(c:cs) | k < c     = k : gaps (k+2) s  -- ~= ([k,k+2..] \\ s)
                  | otherwise =     gaps (k+2) cs --   when null(s\\[k,k+2..])
  _U ((x:xs):t) = x : (merge xs . _U . pairs) t   -- tree-shaped folding big union
  pairs (xs:ys:t) = merge xs ys : pairs t
  merge xs@(x:xt) ys@(y:yt) | x < y     = x : merge xt ys
                            | y < x     = y : merge xs yt
                            | otherwise = x : merge xt yt
