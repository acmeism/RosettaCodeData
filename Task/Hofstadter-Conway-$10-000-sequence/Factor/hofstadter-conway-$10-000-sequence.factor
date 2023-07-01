USING: combinators formatting io kernel locals math math.ranges
prettyprint sequences splitting ;

MEMO:: a ( n -- a(n) )  ! memoize the recurrence relation
    n {
        { 1 [ 1 ] }
        { 2 [ 1 ] }
        [ 1 - a a n n 1 - a - a + ]
    } case ;

20 2^ [1,b] [ [ a ] [ 1 + / ] bi* ] map-index
[
    { 1/2 } split harvest rest-slice
    [ supremum ] map 1 19 [a,b]
    [ dup 1 + [ 2^ ] bi@ "%f max in (%d, %d)\n" printf ]
    2each
]
[ "Mallow's number: " write [ 0.55 >= ] find-last drop 1 + . ]
bi
