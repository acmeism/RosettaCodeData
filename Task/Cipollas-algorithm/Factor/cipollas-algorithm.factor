USING: accessors assocs interpolate io kernel literals locals
math math.extras math.functions ;

TUPLE: point x y ;
C: <point> point

:: (cipolla) ( n p -- m )
    0 0 :> ( a! ω2! )
    [ ω2 p legendere -1 = ]
    [ a sq n - p rem ω2! a 1 + a! ] do until a 1 - a!

    [| a b |
        a x>> b x>> * a y>> b y>> ω2 * * + p mod
        a x>> b y>> * b x>> a y>> * + p mod <point>
    ] :> [mul]

    1 0 <point> :> r!
    a 1 <point> :> s!
    p 1 + -1 shift :> n!

    [ n 0 > ] [
        n odd? [ r s [mul] call r! ] when
        s s [mul] call s!
        n -1 shift n!
    ] while

    r y>> zero? r x>> f ? ;


: cipolla ( n p -- m/f )
    2dup legendere 1 = [ (cipolla) ] [ 2drop f ] if ;

! Task
{
    { 10 13 }
    { 56 101 }
    { 8218 10007 }
    { 8219 10007 }
    { 331575 1000003 }
    { 665165880 1000000007 }
    { 881398088036 1000000000039 }
    ${
        34035243914635549601583369544560650254325084643201
        10 50 ^ 151 +
    }
}
[
    2dup cipolla
    [ 2dup - [I Roots of ${3} are (${1} ${0}) mod ${2}I] ]
    [ [I No solution for (${}, ${})I] ] if* nl
] assoc-each
