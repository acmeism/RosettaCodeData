USING: combinators formatting io kernel math math.combinatorics
prettyprint sequences ;
IN: rosetta-code.derangements

: !n ( n -- m )
    {
        { 0 [ 1 ] }
        { 1 [ 0 ] }
        [ [ 1 - !n ] [ 2 - !n + ] [ 1 - * ] tri ]
    } case ;

: derangements ( n -- seq )
    <iota> dup [ [ = ] 2map [ f = ] all? ] with
    filter-permutations ;

"4 derangements" print 4 derangements . nl
"n   count    calc\n=  ======  ======" print
10 <iota> [
    dup [ derangements length ] [ !n ] bi
    "%d%8d%8d\n" printf
] each nl
"!20 = " write 20 !n .
