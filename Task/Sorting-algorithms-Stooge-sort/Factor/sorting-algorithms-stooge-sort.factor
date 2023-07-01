USING: kernel locals math prettyprint sequences ;
IN: rosetta-code.stooge-sort

<PRIVATE

:: (stooge-sort) ( seq i j -- )
    j i [ seq nth ] bi@ < [
        j i seq exchange
    ] when
    j i - 1 > [
        j i - 1 + 3 /i :> t
        seq i j t - (stooge-sort)
        seq i t + j (stooge-sort)
        seq i j t - (stooge-sort)
    ] when ;

PRIVATE>

: stooge-sort ( seq -- sortedseq )
    [ clone dup ] [ drop 0 ] [ length 1 - ] tri (stooge-sort) ;

: stooge-sort-demo ( -- )
    { 1 4 5 3 -6 3 7 10 -2 -5 } stooge-sort . ;

MAIN: stooge-sort-demo
