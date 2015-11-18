primesTo m = 2 : eratos [3,5..m] where
   eratos (p : xs)
      | p*p > m   = p : xs
      | otherwise = p : eratos (xs `minus` [p*p, p*p+2*p..m])
                                    -- map (p*) [p,p+2..]
                                    -- map (p*) (p:xs)     -- (Euler's sieve)

minus a@(x:xs) b@(y:ys) = case compare x y of
         LT -> x : minus  xs b
         EQ ->     minus  xs ys
         GT ->     minus  a  ys
minus a        b        = a
