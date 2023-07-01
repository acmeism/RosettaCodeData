-- autogenerates wheel primes, first sieve prime, and gaps
wheelGen :: Int -> ([Int],Int,[Int])
wheelGen n = loop 1 3 [2] [2] where
  loop i frst wps gps =
    if i >= n then (wps, frst, gps) else
    let nfrst = frst + head gps
        nhts = (length gps) * (frst - 1)
        cmpsts = scanl (\ c g -> c + frst * g)  (frst * frst) (cycle gps)
        cull n (g:gs') cs@(c:cs') og
            | nn >= c = cull nn gs' cs' (og + g) -- n == c; never greater!
            | otherwise = (og + g) : cull nn gs' cs 0 where nn = n + g
    in nfrst `seq` nhts `seq` loop (i + 1) nfrst (wps ++ [frst]) $ take nhts
                                $ cull nfrst (tail $ cycle gps) cmpsts 0

(wheelPrimes, firstSievePrime, gaps) = wheelGen 7

primesTreeFoldingWheeled :: () -> [Int]
primesTreeFoldingWheeled() =
    wheelPrimes ++ map fst (
      _Y ( ((firstSievePrime, wheel) :) .
               gapsW (firstSievePrime + head wheel, tail wheel) . _U .
                 map (\ (p,w) ->
                          scanl (\ c m -> c + m * p) (p * p) w ) ) ) where

  _Y g = g (_Y g) -- non-sharing multi-stage fixpoint Y-combinator

  wheel = cycle gaps

  gapsW k@(n,d:w) s@(c:cs) | n < c     = k : gapsW (n + d, w) s  -- set diff
                           | otherwise =     gapsW (n + d, w) cs --   n == c

  _U ((x:xs):t) = -- exactly the same as for odds-only!
      x : (union xs . _U . pairs) t where   -- tree-shaped folding big union
    pairs (xs:ys:t) = union xs ys : pairs t --  ~= nub . sort . concat
    union xs@(x:xs') ys@(y:ys')
      | x < y = x : union xs' ys
      | y < x = y : union xs ys'
      | otherwise = x : union xs' ys' -- x and y must be equal!
