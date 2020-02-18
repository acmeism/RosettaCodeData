USING: kernel math math.matrices prettyprint ;

: sierpinski ( n -- )
    1 - { { 1 1 1 } { 1 0 1 } { 1 1 1 } } swap over [ kron ]
    curry times [ 1 = "#" " " ? ] matrix-map simple-table. ;

3 sierpinski
