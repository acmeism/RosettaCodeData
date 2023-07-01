USING: assocs combinators formatting kernel make math sequences ;
IN: rosetta-code.egyptian-division

: table ( dividend divisor -- table )
    [ [ 2dup >= ] [ dup , 2 * ] while ] { } make 2nip
    dup length <iota> [ 2^ ] map zip <reversed> ;

: accum ( a b dividend -- c )
    [ 2dup [ first ] bi@ + ] dip < [ [ + ] 2map ] [ drop ] if ;

: ediv ( dividend divisor -- quotient remainder )
    {
        [ table ]
        [ 2drop { 0 0 } ]
        [ drop [ accum ] curry reduce first2 swap ]
        [ drop - abs ]
    } 2cleave ;

580 34 ediv "580 divided by 34 is %d remainder %d\n" printf
