USING: io kernel lists lists.lazy math math.functions
math.primes prettyprint ;

: repunit ( m -- n ) 10^ 1 - 9 / ;

: composite ( -- list ) 4 lfrom [ prime? not ] lfilter ;

: deceptive ( -- list )
    composite [ [ 1 - repunit ] keep divisor? ] lfilter ;

10 deceptive ltake [ pprint bl ] leach nl
