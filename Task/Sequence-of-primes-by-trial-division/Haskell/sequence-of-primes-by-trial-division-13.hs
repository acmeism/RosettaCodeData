import Data.List (inits)

primesST = 2 : 3 : sieve 5 9 (drop 2 primesST) (inits $ tail primesST)
   where
   sieve x q ps (fs:ft) = filter (\y-> all ((/=0).rem y) fs) [x,x+2..q-2]
                          ++ sieve (q+2) (head ps^2) (tail ps) ft
