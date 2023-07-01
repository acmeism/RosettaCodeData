USING: continuations formatting io kernel locals math
math.factorials math.functions sequences ;

:: integer-term ( n -- m )
    32 6 n * factorial * 532 n sq * 126 n * + 9 + *
    n factorial 6 ^ 3 * / ;

: exponent-term ( n -- m ) 6 * 3 + neg ;

: nth-term ( n -- x )
    [ integer-term ] [ exponent-term 10^ * ] bi ;

! Factor doesn't have an arbitrary-precision square root afaik,
! so make one using Heron's method.

: sqrt-approx ( r x -- r' x ) [ over / + 2 / ] keep ;

:: almkvist-guillera ( precision -- x )
    0 0 :> ( summed! next-add! )
    [
        100,000,000 <iota> [| n |
            summed n nth-term + next-add!
            next-add summed - abs precision neg 10^ <
            [ return ] when
            next-add summed!
        ] each
    ] with-return
    next-add ;

CONSTANT: 1/pi 113/355  ! Use as initial guess for square root approximation

: pi ( -- )
    1/pi 70 almkvist-guillera 5 [ sqrt-approx ] times
    drop recip "%.70f\n" printf ;

! Task
"N                               Integer Portion  Pow  Nth Term (33 dp)" print
89 CHAR: - <repetition> print
10 [
    dup [ integer-term ] [ exponent-term ] [ nth-term ] tri
    "%d  %44d  %3d  %.33f\n" printf
] each-integer nl
"Pi to 70 decimal places:" print pi
