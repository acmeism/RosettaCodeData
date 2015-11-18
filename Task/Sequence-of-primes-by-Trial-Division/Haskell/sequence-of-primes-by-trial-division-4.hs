primesT = sieve [2..]
          where
          sieve (p:xs) = p : sieve [x | x <- xs, rem x p /= 0]
-- map head
--  . iterate (\(p:xs)-> filter ((>0).(`rem`p)) xs) $ [2..]
