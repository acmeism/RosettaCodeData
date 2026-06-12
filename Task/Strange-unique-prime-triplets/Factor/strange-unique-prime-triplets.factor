USING: formatting io kernel math math.combinatorics math.primes
sequences tools.memory.private ;

: .triplet ( seq -- ) "%2d+%2d+%2d = %d\n" vprintf ;

: strange ( n -- )
    primes-upto 3
    [ dup sum dup prime? [ suffix .triplet ] [ 2drop ] if ]
    each-combination ;

: count-strange ( n -- count )
    0 swap primes-upto 3
    [ sum prime? [ 1 + ] when ] each-combination ;

30 strange
1,000 count-strange commas nl
"Found %s strange prime triplets with n, m, p < 1,000.\n" printf
