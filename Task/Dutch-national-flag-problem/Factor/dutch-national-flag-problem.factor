USING: combinators grouping kernel math prettyprint random
sequences ;

: sorted? ( seq -- ? ) [ <= ] monotonic? ;

: random-non-sorted-integers ( length n -- seq )
    2dup random-integers
    [ dup sorted? ] [ drop 2dup random-integers ] while 2nip ;

: dnf-sort! ( seq -- seq' )
    [ 0 0 ] dip [ length 1 - ] [ ] bi
    [ 2over <= ] [
        pick over nth {
            { 0 [ reach reach pick exchange [ [ 1 + ] bi@ ] 2dip ] }
            { 1 [ [ 1 + ] 2dip ] }
            [ drop 3dup exchange [ 1 - ] dip ]
        } case
    ] while 3nip ;

10 3 random-non-sorted-integers dup . dnf-sort! .
