USING: assocs assocs.extras kernel math.primes math.statistics
prettyprint ;

1000 primes-upto dup cum-sum zip [ prime? ] filter-values .
