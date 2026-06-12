USING: assocs assocs.extras kernel math.primes math.statistics
prettyprint sequences.extras ;

1000 primes-upto <evens> dup cum-sum zip [ prime? ] filter-values .
