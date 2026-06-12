USING: formatting grouping io kernel math.parser math.primes
present prettyprint sequences sets sorting ;

"Concatenated-pair primes from primes < 100:" print nl
99 primes-upto [ present ] map dup [ append dec> ] cartesian-map
concat [ prime? ] filter members natural-sort [ length ] keep
8 group simple-table. "\nFound %d concatenated primes.\n" printf
