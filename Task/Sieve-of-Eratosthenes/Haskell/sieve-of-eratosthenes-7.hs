import Data.List (inits)

primesSE = 2 : sieve 3 4 (tail primesSE) (inits primesSE)
               where
               sieve x q ps (fs:ft) =
                  foldl minus [x..q-1] [[n, n+f..q-1] | f <- fs, let n=div x f * f]
                          -- [i|(i,True) <- assocs ( accumArray (\ b c -> False)
                          --     True (x,q-1) [(i,()) | f <- fs, let n=div(x+f-1)f*f,
                          --         i <- [n, n+f..q-1]] :: UArray Int Bool )]
                  ++ sieve q (head ps^2) (tail ps) ft
