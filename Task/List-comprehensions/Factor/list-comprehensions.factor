USING: backtrack kernel locals math math.ranges ;

:: pythagorean-triples ( n -- seq )
    [
          n [1,b] amb-lazy :> a
        a n [a,b] amb-lazy :> b
        b n [a,b] amb-lazy :> c
        a a * b b * + c c * = must-be-true { a b c }
    ] bag-of ;
