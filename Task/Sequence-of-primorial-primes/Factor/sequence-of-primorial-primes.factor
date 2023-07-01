USING: kernel lists lists.lazy math math.primes prettyprint
sequences ;

: pprime? ( n -- ? )
    nprimes product [ 1 + ] [ 1 - ] bi [ prime? ] either? ;

10 1 lfrom [ pprime? ] <lazy-filter> ltake list>array .
