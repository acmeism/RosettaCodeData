USING: arrays fry io kernel math math.combinatorics
math.matrices prettyprint sequences ;

: pascal ( n quot -- m )
    [ dup 2array <coordinate-matrix> ] dip
    '[ first2 @ nCk ] matrix-map ; inline

: lower ( n -- m ) [ ] pascal ;
: upper ( n -- m ) lower flip ;
: symmetric ( n -- m ) [ [ + ] keep ] pascal ;

5
[ lower "Lower:" ]
[ upper "Upper:" ]
[ symmetric "Symmetric:" ] tri
[ print simple-table. nl ] 2tri@
