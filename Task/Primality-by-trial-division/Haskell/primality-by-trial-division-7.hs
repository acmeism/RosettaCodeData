primesST = 2 : 3 : sieve 5 9 (drop 2 primesST) 0 where
   sieve x q ps k = let fs = take k (tail primesST) in
      filter (\x-> all ((/=0).rem x) fs) [x,x+2..q-2]
      ++ sieve (q+2) (head ps^2) (tail ps) (k+1)
