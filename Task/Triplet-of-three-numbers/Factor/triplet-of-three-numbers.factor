USING: combinators formatting grouping kernel math math.primes
math.statistics sequences ;

: 4,2-gaps ( upto -- seq )
    4 + primes-upto 3 <clumps>
    [ differences { 4 2 } sequence= ] filter ;

: triplet. ( 1 n 2 3 -- )
    "..., %4d, [%4d], __, __, %4d, __, %4d, ...\n" printf ;

6000 4,2-gaps [ first3 [ dup 1 + ] 2dip triplet. ] each
