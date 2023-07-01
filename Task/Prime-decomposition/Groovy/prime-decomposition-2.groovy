((1..30) + [97*4, 1000, 1024, 333333]).each { println ([number:it, primes:decomposePrimes(it)]) }
