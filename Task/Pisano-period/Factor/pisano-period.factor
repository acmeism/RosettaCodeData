USING: formatting fry grouping io kernel math math.functions
math.primes math.primes.factors math.ranges sequences ;

: pisano-period ( m -- n )
    [ 0 1 ] dip [ sq <iota> ] [ ] bi
    '[ drop tuck + _ mod 2dup [ zero? ] [ 1 = ] bi* and ]
    find 3nip [ 1 + ] [ 1 ] if* ;

: pisano-prime ( p k -- n )
    over prime? [ "p must be prime." throw ] unless
    ^ pisano-period ;

: pisano ( m -- n )
    group-factors [ first2 pisano-prime ] [ lcm ] map-reduce ;

: show-pisano ( upto m -- )
    [ primes-upto ] dip
    [ 2dup pisano-prime "%d %d pisano-prime = %d\n" printf ]
    curry each nl ;

15  2 show-pisano
180 1 show-pisano

"n pisano for integers 'n' from 2 to 180:" print
2 180 [a,b] [ pisano ] map 15 group
[ [ "%3d " printf ] each nl ] each
