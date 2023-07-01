USING: arrays formatting io kernel make math math.extras
sequences ;
IN: rosetta-code.mayan-numerals

: mayan-digit ( n -- m pair ) 20 /mod 5 /mod swap 2array ;

: integer>mayan ( n -- seq )
    [ [ mayan-digit , ] until-zero ] { } make reverse ;

: ones ( n -- str ) [ CHAR: ● ] "" replicate-as ;
: fives ( n -- str ) [ "——" ] replicate "<br>" join ;

: numeral ( pair -- str )
    dup sum zero? [ drop "Θ" ]
    [ first2 [ ones ] [ fives ] bi* 2array harvest "<br>" join ]
    if ;

: .table-row ( pair -- )
    "|style=\"width:3em;vertical-align:bottom;\"|" write numeral
    print ;

: .table-head ( -- )
    "class=\"wikitable\" style=\"text-align:center;\"" print ;

: .table-body ( n -- ) integer>mayan [ .table-row ] each ;

: .mayan ( n -- )
    [ "Mayan %d:\n" printf ]
    [ "{|" write .table-head .table-body "|}" print ] bi ;

: mayan-numerals ( -- )
    { 4005 8017 326205 886205 } [ .mayan ] each ;

MAIN: mayan-numerals
