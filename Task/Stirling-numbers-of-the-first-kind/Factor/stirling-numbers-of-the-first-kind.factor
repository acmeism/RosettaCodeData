USING: arrays assocs formatting io kernel math math.polynomials
math.ranges prettyprint sequences ;
IN: rosetta-code.stirling-first

: stirling-row ( n -- seq )
    [ { 1 } ] [
        [ -1 ] dip neg [a,b) dup length 1 <array> zip
        { 0 1 } [ p* ] reduce [ abs ] map
    ] if-zero ;

"Unsigned Stirling numbers of the first kind:" print
"n\\k" write 13 dup [ "%10d" printf ] each-integer nl

[ dup "%-2d " printf stirling-row [ "%10d" printf ] each nl ]
each-integer nl

"Maximum value from 100th stirling row:" print
100 stirling-row supremum .
