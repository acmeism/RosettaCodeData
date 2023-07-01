USING: combinators combinators.short-circuit formatting infix io
kernel locals math math.factorials math.ranges prettyprint
sequences ;
IN: rosetta-code.lah-numbers

! Yes, Factor can do infix arithmetic with local variables!
! This is a good use case for it.

INFIX:: (lah) ( n k -- m )
    ( factorial(n) * factorial(n-1) ) /
    ( factorial(k) * factorial(k-1) ) / factorial(n-k) ;

:: lah ( n k -- m )
    {
        { [ k 1 = ] [ n factorial ] }
        { [ k n = ] [ 1 ] }
        { [ k n > ] [ 0 ] }
        { [ k 1 < n 1 < or ] [ 0 ] }
        [ n k (lah) ]
    } cond ;

"Unsigned Lah numbers: n k lah:" print
"n\\k" write 13 dup [ "%11d" printf ] each-integer nl

<iota> [
    dup dup "%-2d " printf [0,b] [
        lah "%11d" printf
    ] with each nl
] each nl

"Maximum value from the 100 _ lah row:" print
100 [0,b] [ 100 swap lah ] map supremum .
