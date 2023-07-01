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

primesTDW :: () -> [Int]
primesTDW() = wheelPrimes ++ _Y (
                (firstSievePrime :) . sieve (firstSievePrime + head gaps)
                                            (tail $ cycle gaps)) where
  _Y g = g (_Y g)        -- non-sharing multi-stage fixpoint combinator
  sieve cnd gps bps = xtrprms cnd gps where
    xtrprms n (g:gs') -- strictly filtered by base primes <= sqrt - faster!
      | any ((==) 0 . rem n)
            (takeWhile ((<= n) . flip (^) 2) bps) = xtrprms (n + g) gs'
      | otherwise = n : xtrprms (n + g) gs'
