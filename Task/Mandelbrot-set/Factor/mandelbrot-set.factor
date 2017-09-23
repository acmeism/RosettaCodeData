! with ("::") or without (":") generalizations:
! : [a..b] ( steps a b -- a..b ) 2dup swap - 4 nrot 1 - / <range> ;
::  [a..b] ( steps a b -- a..b ) a b b a - steps 1 - / <range> ;

: >char ( n -- c )
    dup -1 = [ drop 32 ] [ 26 mod CHAR: a + ] if ;

! iterates z' = z^2 + c, Factor does complex numbers!
: iter ( c z -- z' ) dup * + ;

: unbound ( c -- ? ) absq 4 > ;

:: mz ( c max i z -- n )
  {
    { [ i max >= ] [ -1 ] }
    { [ z unbound ] [ i ] }
    [ c max i 1 + c z iter mz ]
  } cond ;

: mandelzahl ( c max -- n ) 0 0 mz ;

:: mandel ( w h max -- )
    h -1. 1. [a..b] ! range over y
    [   w -2. 1. [a..b] ! range over x
        [ dupd swap rect> max mandelzahl >char ] map
        >string print
        drop ! old y
    ] each
    ;

70 25 1000 mandel
