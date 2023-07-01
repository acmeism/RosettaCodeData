USING: combinators.short-circuit formatting io kernel math
math.extras prettyprint sequences ;
RENAME: stirling math.extras => (stirling)
IN: rosetta-code.stirling-second

! Tweak Factor's in-built stirling function for k=0
: stirling ( n k -- m )
    2dup { [ = not ] [ nip zero? ] } 2&&
    [ 2drop 0 ] [ (stirling) ] if ;

"Stirling numbers of the second kind: n k stirling:" print
"n\\k" write 13 dup [ "%8d" printf ] each-integer nl

<iota> [
    dup dup "%-2d " printf [0,b] [
        stirling "%8d" printf
    ] with each nl
] each nl

"Maximum value from the 100 _ stirling row:" print
100 <iota> [ 100 swap stirling ] map supremum .
