USING: io kernel math math.primes.factors prettyprint sequences ;

: next ( n num -- n' num' )
    [ 2dup divisors length = ] [ 1 + ] do until [ 1 + ] dip ;

: A069654 ( n -- seq )
    [ 2 1 ] dip [ [ next ] keep ] replicate 2nip ;

"The first 15 terms of the sequence are:" print 15 A069654 .
