primes = 2 : 3 : [n | n <- [5,7..], foldr (\p r-> p*p > n || rem n p > 0 && r)
                                          True (drop 1 primes)]
       = [2,3,5] ++ [n | n <- scanl (+) 7 (cycle [4,2]),
                                     foldr (\p r-> p*p > n || rem n p > 0 && r)
                                           True (drop 2 primes)]
    -- = [2,3,5,7] ++ [n | n <- scanl (+) 11 (cycle [2,4,2,4,6,2,6,4]), ... (drop 3 primes)]
