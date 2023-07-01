USING: accessors combinators combinators.short-circuit
formatting io kernel literals locals math math.distances
math.functions prettyprint sequences strings ;
IN: rosetta-code.circles
DEFER: find-circles

! === Input ====================================================

TUPLE: input p1 p2 r ;

CONSTANT: test-cases {
    T{ input f { 0.1234 0.9876 } { 0.8765 0.2345 } 2 }
    T{ input f { 0 2 } { 0 0 } 1 }
    T{ input f { 0.1234 0.9876 } { 0.1234 0.9876 } 2 }
    T{ input f { 0.1234 0.9876 } { 0.8765 0.2345 } 0.5 }
    T{ input f { 0.1234 0.9876 } { 0.1234 0.9876 } 0 }
}

! === Edge case handling =======================================

CONSTANT: infinite
    "there could be an infinite number of circles."

CONSTANT: too-far
    "points are too far apart to form circles."

: coincident? ( input -- ? ) [ p1>> ] [ p2>> ] bi = ;

: degenerate? ( input -- ? )
    { [ r>> zero? ] [ coincident? ] } 1&& ;

: infinite? ( input -- ? )
    { [ r>> zero? not ] [ coincident? ] } 1&& ;

: too-far? ( input -- ? )
    [ r>> 2 * ] [ p1>> ] [ p2>> ] tri euclidian-distance < ;

: degenerate ( input -- str )
    p1>> [ first ] [ second ] bi
    "one degenerate circle found at (%.4f, %.4f).\n" sprintf ;

: check-input ( input -- obj )
    {
        { [ dup infinite?   ] [ drop infinite ] }
        { [ dup too-far?    ] [ drop too-far  ] }
        { [ dup degenerate? ] [ degenerate    ] }
        [ find-circles ]
    } cond ;

! === Program Logic ============================================

:: (circle-coords) ( a b c r q quot -- x )
    a r sq q 2 / sq - sqrt b c - * q / quot call ; inline

: circle-coords ( quot -- x y )
    [ + ] over [ - ] [ [ call ] dip (circle-coords) ] 2bi@ ;
    inline

:: find-circles ( input -- circles )
    input [ r>> ] [ p1>> ] [ p2>> ] tri    :> ( r p1 p2 )
    p1 p2 [ [ first ] [ second ] bi ] bi@  :> ( x1 y1 x2 y2 )
    x1 x2 y1 y2 [ + 2 / ] 2bi@             :> ( x3 y3 )
    p1 p2 euclidian-distance               :> q
    [ x3 y1 y2 r q ]
    [ y3 x2 x1 r q ] [ circle-coords ] bi@ :> ( x w y z )
    { x y } { w z } = { { x y } } { { w z } { x y } } ? ;

! === Output ===================================================

: .point ( seq -- )
    [ first ] [ second ] bi "(%.4f, %.4f)" printf ;

: .given ( input -- )
    [ r>> ] [ p2>> ] [ p1>> ] tri
    "Given points " write .point ", " write .point
    ", and radius %.2f,\n" printf ;

: .one ( seq -- )
    first "one circle found at " write .point "." print ;

: .two ( seq -- )
    [ first ] [ second ] bi "two circles found at " write
    .point " and " write .point "." print ;

: .circles ( seq -- ) dup length 1 = [ .one ] [ .two ] if ;

! === Main word ================================================

: circles-demo ( -- )
    test-cases [
        dup .given check-input dup string?
        [ print ] [ .circles ] if nl
    ] each ;

MAIN: circles-demo
