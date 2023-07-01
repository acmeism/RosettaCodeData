def isPrime = {factorize(it).size() == 2}
(1..60).step(2).findAll(isPrime).each { println ([number:"2**${it}-1", value:2**it-1, primes:decomposePrimes(2**it-1)]) }
