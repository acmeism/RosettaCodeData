USING: combinators.short-circuit grouping.extras kernel math
math.functions math.primes math.primes.factors math.vectors
prettyprint ranges sequences sequences.extras ;
IN: calmo

: calmo? ( n -- ? )
    divisors 1 -1 rot subseq* {
        [ empty? not ]
        [ length 3 divisor? ]
        [ [ + + prime? ] 3 group-map vall? ]
    } 1&& ;

MAIN: [ 2 1000 [a..b) [ calmo? ] filter . ]
