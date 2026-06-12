USING: kernel math.parser math.primes prettyprint sequences
sequences.extras ;

500 primes-upto [ >hex ] [ dup reverse = ] map-filter .
