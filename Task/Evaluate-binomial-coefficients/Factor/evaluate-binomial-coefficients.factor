: fact ( n -- n-factorial )
    dup 0 = [ drop 1 ] [ dup 1 - fact * ] if ;

: choose ( n k -- n-choose-k )
    2dup - [ fact ] tri@ * / ;

! outputs 10
5 3 choose .

! alternative using folds
USE: math.ranges

! (product [n..k+1] / product [n-k..1])
: choose-fold ( n k -- n-choose-k )
    2dup 1 + [a,b] product -rot - 1 [a,b] product / ;
