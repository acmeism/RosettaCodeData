import Data.Array.Unboxed
import Data.List (tails, inits)

primes = 2 : [ n |
   (r:q:_, px) <- zip (tails (2 : [p*p | p <- primes]))
                      (inits primes),
   (n, True)   <- assocs ( accumArray (\_ _ -> False) True
                     (r+1,q-1)
                     [ (m,()) | p <- px
                              , s <- [ div (r+p) p * p]
                              , m <- [s,s+p..q-1] ] :: UArray Int Bool
                  ) ]
