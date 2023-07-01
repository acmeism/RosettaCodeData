USING: io kernel math math.matrices.extras sequences ;

: mat-kron-pow ( m n -- m' )
    1 - [ dup kronecker-product ] times ;

: print-fractal ( m -- )
    [ [ 1 = "*" " " ? write ] each nl ] each ;

{ { 0 1 0 } { 1 1 1 } { 0 1 0 } }
{ { 1 1 1 } { 1 0 1 } { 1 1 1 } }
{ { 0 1 1 } { 0 1 0 } { 1 1 0 } }
[ 3 mat-kron-pow print-fractal ] tri@
