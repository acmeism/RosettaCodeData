USING: infix locals prettyprint sequences
sequences.generalizations sequences.repeating ;

:: row ( x p -- seq )
    x p "-x**p" [infix -x**p infix]
    "-(x)**p" [infix -(x)**p infix]
    "(-x)**p" [infix (-x)**p infix]
    "-(x**p)" [infix -(x**p) infix] 10 narray ;

{ "x value" "p value" } { "expression" "result" } 8 cycle append
-5 2 row
-5 3 row
5 2 row
5 3 row
5 narray simple-table.
