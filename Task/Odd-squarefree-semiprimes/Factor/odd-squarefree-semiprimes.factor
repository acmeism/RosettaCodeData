USING: combinators.short-circuit formatting grouping io kernel
math.primes.factors math.ranges prettyprint sequences sets ;

: sq-free-semiprime? ( n -- ? )
    factors { [ length 2 = ] [ all-unique? ] } 1&& ;

: odd-sfs-upto ( n -- seq )
    1 swap 2 <range> [ sq-free-semiprime? ] filter ;

999 odd-sfs-upto dup length
"Found %d odd square-free semiprimes < 1000:\n" printf
20 group [ [ "%4d" printf ] each nl ] each nl
