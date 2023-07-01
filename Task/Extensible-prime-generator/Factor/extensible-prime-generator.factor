USING: io math.primes prettyprint sequences ;

"First 20 primes: " write
20 nprimes .

"Primes between 100 and 150: " write
100 150 primes-between .

"Number of primes between 7,700 and 8,000: " write
7,700 8,000 primes-between length .

"10,000th prime: " write
10,000 nprimes last .
