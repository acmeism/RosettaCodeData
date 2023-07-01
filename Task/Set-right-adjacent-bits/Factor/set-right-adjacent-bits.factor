USING: formatting io kernel math math.parser math.ranges
sequences ;

: set-rab ( n b -- result )
    [0,b] [ neg shift ] with [ bitor ] map-reduce ;

:: show ( n b e -- )
    b e "n = %d; width = %d\n" printf
    n n b set-rab [ >bin e CHAR: 0 pad-head print ] bi@ ;

{ 0b1000 0b0100 0b0010 0b0000 } [ 2 4 show nl ] each
0x10020080404082112 4 <iota> [ 66 show nl ] with each
