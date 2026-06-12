USING: math math.primes prettyprint sequences ;

: digital-root ( m -- n ) 1 - 9 mod 1 + ;

500 1000 primes-between [ digital-root prime? ] filter .
