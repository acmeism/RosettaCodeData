USING: formatting fry io kernel locals math math.functions
math.ranges sequences ;
IN: rosetta-code.pathological

: next2 ( x y -- y z )
    swap dupd dupd '[ 111 1130 _ / - 3000 _ _ * / + ] call ;

: pathological-sequence ( -- seq )
    2 -4 100 [ next2 dup ] replicate 2nip { 0 2 -4 } prepend ;

: show-sequence ( -- )
    { 3 4 5 6 7 8 20 30 50 100 } dup pathological-sequence nths
    [ "n = %-3d %21.16f\n" printf ] 2each ;

CONSTANT: e 106246577894593683/39085931702241241
: balance ( n -- x ) [1,b] e 1 - [ * 1 - ] reduce ;

:: f ( a b -- x )
    333+3/4 b 6 ^ * 11 a sq b sq * * b 6 ^ - b 4 ^ 121 * - 2 - a
    sq * b 8 ^ 5+1/2 * a 2 b * / + + + ;

: pathological-demo ( -- )
    "Task 1 - Sequence convergence:" print show-sequence nl

    "Task 2 - Chaotic Bank fund after 25 years:" print
    25 balance "%.16f\n" printf nl

    "Task 3 - Siegfried Rump's example:" print
    77617 33096 f "77617 33096 f = %.16f\n" printf ;

MAIN: pathological-demo
