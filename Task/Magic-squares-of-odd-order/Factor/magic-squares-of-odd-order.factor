USING: formatting io kernel math math.matrices math.ranges
sequences sequences.extras ;
IN: rosetta-code.magic-squares-odd

: inc-matrix ( n -- matrix )
    [ 0 ] dip dup [ 1 + dup ] make-matrix nip ;

: rotator ( n -- seq ) 2/ dup [ neg ] dip [a,b] ;

: odd-magic-square ( n -- matrix )
    [ inc-matrix ] [ rotator [ rotate ] 2map flip ] dup tri ;

: show-square ( n -- )
    dup "Order: %d\n" printf odd-magic-square dup
    [ [ "%4d" printf ] each nl ] each first sum
    "Magic number: %d\n\n" printf ;

3 5 11 [ show-square ] tri@
