USING: formatting kernel math math.combinatorics math.extras
math.functions regexp sequences ;

: faulhaber ( p -- seq )
    1 + dup recip swap dup <iota>
    [ [ nCk ] [ -1 swap ^ ] [ bernoulli ] tri * * * ] 2with map ;

: (poly>str) ( seq -- str )
    reverse [ 1 + "%un^%d" sprintf ] map-index reverse " + " join ;

: clean-up ( str -- str' )
    R/ n\^1\z/ "n" re-replace            ! Change n^1 to n.
    R/ 1n/ "n" re-replace                ! Change 1n to n.
    R/ \+ -/ "- " re-replace             ! Change + - to - .
    R/ [+-] 0n(\^\d+ )?/ "" re-replace ; ! Remove terms of zero.

: poly>str ( seq -- str ) (poly>str) clean-up ;

10 [ dup faulhaber poly>str "%d: %s\n" printf ] each-integer
