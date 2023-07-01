USING: arrays combinators formatting kernel math.combinatorics
math.order math.statistics sequences sets sorting ;

: overlaps? ( pair pair -- ? )
    2dup swap [ [ first2 between? ] curry any? ] 2bi@ or ;

: merge ( seq -- newseq ) concat minmax 2array 1array ;

: merge1 ( seq -- newseq )
    dup 2 [ first2 overlaps? ] find-combination
    [ [ without ] keep merge append ] when* ;

: normalize ( seq -- newseq ) [ natural-sort ] map ;

: consolidate ( seq -- newseq )
    normalize [ merge1 ] to-fixed-point natural-sort ;

{
    { { 1.1 2.2 } }
    { { 6.1 7.2 } { 7.2 8.3 } }
    { { 4 3 } { 2 1 } }
    { { 4 3 } { 2 1 } { -1 -2 } { 3.9 10 } }
    { { 1 3 } { -6 -1 } { -4 -5 } { 8 2 } { -6 -6 } }
} [ dup consolidate "%49u => %u\n" printf ] each
