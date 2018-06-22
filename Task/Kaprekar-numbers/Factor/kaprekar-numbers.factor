USING: grouping.extras kernel math math.parser math.ranges
math.text.utils prettyprint sequences sequences.extras
splitting ;
IN: rosetta-code.kaprekar

: digits ( n -- digits )
    1 digit-groups reverse ;

: digit-pairs ( digits -- seq1 seq2 )
    [ tail-clump ] [ head-clump ] bi [ 1 rotate ] dip ;

: digit-pairs>number-pairs ( seq1 seq2 -- seq1' seq2' )
    [ [ 10 digits>integer ] map but-last ] bi@ ;

: remove-zeros ( seq1 seq2 -- seq1' seq2' )
    [ [ 0 = ] split1-when drop ] bi@ ;

: kaprekar-pairs ( n -- seq1 seq2 )
    digits digit-pairs digit-pairs>number-pairs remove-zeros ;

: kaprekar? ( n -- ? )
    dup sq kaprekar-pairs [ + ] 2map member? ;

: main ( -- )
    10000 [1,b) [ kaprekar? ] filter { 1 } prepend . ;

MAIN: main
