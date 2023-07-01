USING: assocs compiler.tree.propagation.call-effect formatting
kernel math math.functions math.statistics math.text.utils
sequences ;
IN: rosetta-code.benfords-law

: expected ( n -- x ) recip 1 + log10 ;

: next-fib ( vec -- vec' )
    [ last2 ] keep [ + ] dip [ push ] keep ;

: data ( -- seq ) V{ 1 1 } clone 998 [ next-fib ] times ;

: 1st-digit ( n -- m ) 1 digit-groups last ;

: leading ( -- seq ) data [ 1st-digit ] map ;

: .header ( -- )
    "Digit" "Expected" "Actual" "%-10s%-10s%-10s\n" printf ;

: digit-report ( digit digit-count -- digit expected actual )
    dupd [ expected ] dip 1000 /f ;

: .digit-report ( digit digit-count -- )
    digit-report "%-10d%-10.4f%-10.4f\n" printf ;

: main ( -- )
    .header leading histogram [ .digit-report ] assoc-each ;

MAIN: main
