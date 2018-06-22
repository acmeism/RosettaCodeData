USING: formatting fry kernel lists lists.lazy locals
math.combinatorics math.primes.factors math.ranges sequences ;
IN: rosetta-code.almost-prime

: k-almost-prime? ( n k -- ? )
    '[ factors _ <combinations> [ product ] map ]
    [ [ = ] curry ] bi any? ;

:: first10 ( k -- seq )
    10 0 lfrom [ k k-almost-prime? ] lfilter ltake list>array ;

5 [1,b] [ dup first10 "K = %d: %[%3d, %]\n" printf ] each
