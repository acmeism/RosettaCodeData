USING: kernel prettyprint sorting.extras sequences ;

: insertion-sort ( seq -- sorted-seq )
    <reversed> V{ } clone [ swap insort-left! ] reduce ;

{ 6 8 5 9 3 2 1 4 7 } insertion-sort .
