USING: assocs formatting kernel math.primes math.ranges
math.statistics prettyprint ;

1000 [ [1,b] ] [ primes-upto cum-sum ] bi zip
[ nip prime? ] assoc-filter
[ "The sum of the first  %3d  primes is  %5d  (which is prime).\n" printf ] assoc-each
