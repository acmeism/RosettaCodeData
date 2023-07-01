USING: assocs io kernel math math.parser qw sequences
sequences.generalizations ;

: mod/ ( x y -- w z ) /mod swap ;

: convert ( n -- seq )
    60 mod/ 60 mod/ 24 mod/ 7 mod/ 5 narray reverse ;

: .time ( n -- )
    convert [ number>string ] map qw{ wk d hr min sec } zip
    [ first "0" = ] reject [ " " join ] map ", " join print ;

7259 86400 6000000 [ .time ] tri@
