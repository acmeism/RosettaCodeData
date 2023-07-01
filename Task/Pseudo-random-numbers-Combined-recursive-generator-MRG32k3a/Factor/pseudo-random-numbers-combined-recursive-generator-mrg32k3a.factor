USING: arrays kernel math math.order math.statistics
math.vectors prettyprint sequences ;

CONSTANT: m1 4294967087
CONSTANT: m2 4294944443

: seed ( n -- seq1 seq2 )
    dup 1 m1 between? t assert= 0 0 3array dup ;

: new-state ( seq1 seq2 n -- new-seq )
    [ dup ] [ vdot ] [ rem prefix but-last ] tri* ;

: next-state ( a b -- a' b' )
    [ { 0 1403580 -810728 } m1 new-state ]
    [ { 527612 0 -1370589 } m2 new-state ] bi* ;

: next-int ( a b -- a' b' n )
    next-state 2dup [ first ] bi@ - m1 rem 1 + ;

: next-float ( a b -- a' b' x ) next-int m1 1 + /f ;

! Task
1234567 seed 5 [ next-int . ] times 2drop

987654321 seed 100,000 [ next-float 5 * >integer ] replicate
2nip histogram .
