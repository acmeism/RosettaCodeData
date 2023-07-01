USING: backtrack formatting kernel locals math math.ranges
sequences sets sorting ;
IN: rosetta-code.law-of-cosines

:: triples ( quot -- seq )
    [
        V{ } clone :> seen
        13 [1,b] dup dup [ amb-lazy ] tri@ :> ( a b c )
        a sq b sq + a b quot call( x x x -- x ) c sq =
        { b a c } seen member? not and
        must-be-true { a b c } dup seen push
    ] bag-of ;

: show-solutions ( quot angle -- )
    [ triples { } like dup length ] dip rot
    "%d solutions for %d degrees:\n%u\n\n" printf ;

[ * + ] 120
[ 2drop 0 - ] 90
[ * - ] 60 [ show-solutions ] 2tri@
