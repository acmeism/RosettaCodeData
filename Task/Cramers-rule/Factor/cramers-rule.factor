USING: kernel math math.matrices.laplace prettyprint sequences ;
IN: rosetta-code.cramers-rule

: replace-col ( elt n seq -- seq' ) flip [ set-nth ] keep flip ;

: solve ( m v -- seq )
    dup length <iota> [
        rot [ replace-col ] keep [ determinant ] bi@ /
    ] 2with map ;

: cramers-rule-demo ( -- )
    {
        { 2 -1  5  1 }
        { 3  2  2 -6 }
        { 1  3  3 -1 }
        { 5 -2 -3  3 }
    }
    { -3 -32 -47 49 } solve . ;

MAIN: cramers-rule-demo
