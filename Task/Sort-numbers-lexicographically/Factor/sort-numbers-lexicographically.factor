USING: formatting kernel math.parser math.ranges sequences
sorting ;
IN: rosetta-code.lexicographical-numbers

: lex-order ( n -- seq )
    [1,b] [ number>string ] map natural-sort
    [ string>number ] map ;

{ 13 21 -22 } [ dup lex-order "%3d: %[%d, %]\n" printf ] each
