-- primes = filter isPrime [2..]
primes = 2 : [n | n <- [3..], foldr (\p r-> p*p > n || rem n p > 0 && r)
                                    True primes]
