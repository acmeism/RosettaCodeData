USING: formatting grouping io kernel math.primes.factors
math.ranges math.text.utils sequences sequences.deep ;

: (smith?) ( n factors -- ? )
    [ 1 digit-groups sum ]
    [ [ 1 digit-groups ] map flatten sum = ] bi* ; inline

: smith? ( n -- ? )
    dup factors dup length 1 = [ 2drop f ] [ (smith?) ] if ;

10,000 [1,b] [ smith? ] filter 10 group
[ [ "%4d " printf ] each nl ] each
