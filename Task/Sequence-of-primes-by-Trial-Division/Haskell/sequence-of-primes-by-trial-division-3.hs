primes = 2 : 3 : [n | n <- [5,7..], foldr (\p r-> p*p > n || rem n p > 0 && r)
                                          True (drop 1 primes)]
