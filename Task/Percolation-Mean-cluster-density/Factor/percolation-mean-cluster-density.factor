USING: combinators formatting generalizations kernel math
math.matrices random sequences ;
IN: rosetta-code.mean-cluster-density

CONSTANT: p 0.5
CONSTANT: iterations 5

: rand-bit-matrix ( n probability -- matrix )
    dupd [ random-unit > 1 0 ? ] curry make-matrix ;

: flood-fill ( x y matrix -- )
    3dup ?nth ?nth 1 = [
        [ [ -1 ] 3dip nth set-nth ] [
            {
                [ [ 1 + ] 2dip ]
                [ [ 1 - ] 2dip ]
                [ [ 1 + ] dip ]
                [ [ 1 - ] dip ]
            } [ flood-fill ] map-compose 3cleave
        ] 3bi
    ] [ 3drop ] if ;

: count-clusters ( matrix -- Cn )
    0 swap dup dim matrix-coordinates flip concat [
        first2 rot 3dup ?nth ?nth 1 = [ flood-fill 1 + ]
        [ 3drop ] if
    ] with each ;

: mean-cluster-density ( matrix -- mcd )
    [ count-clusters ] [ dim first sq / ] bi ;

: simulate ( n -- avg-mcd )
    iterations swap [ p rand-bit-matrix mean-cluster-density ]
    curry replicate sum iterations / ;

: main ( -- )
    { 4 64 256 1024 4096 } [
        [ iterations p ] dip dup simulate
        "iterations = %d p = %.1f n = %4d sim = %.5f\n" printf
    ] each ;

MAIN: main
