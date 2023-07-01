USING: assocs formatting io kernel math math.primes.factors
math.ranges sequences sequences.extras ;

ERROR: nonpositive n ;

: (tau) ( n -- count )
    group-factors values [ 1 + ] map-product ; inline

: tau ( n -- count ) dup 0 > [ (tau) ] [ nonpositive ] if ;

"Number of divisors for integers 1-100:" print nl
" n   |                   tau(n)" print
"-----+-----------------------------------------" print
1 100 10 <range> [
    [ "%2d   |" printf ]
    [ dup 10 + [a,b) [ tau "%4d" printf ] each nl ] bi
] each
