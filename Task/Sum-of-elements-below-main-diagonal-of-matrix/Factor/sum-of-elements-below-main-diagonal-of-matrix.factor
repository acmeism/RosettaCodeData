USING: kernel math math.matrices prettyprint sequences ;

: sum-below-diagonal ( matrix -- sum )
    dup square-matrix? [ "Matrix must be square." throw ] unless
    0 swap [ head sum + ] each-index ;

{
    { 1 3 7 8 10 }
    { 2 4 16 14 4 }
    { 3 1 9 18 11 }
    { 12 14 17 18 20 }
    { 7 1 3 9 5 }
} sum-below-diagonal .
