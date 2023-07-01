USING: accessors fry io kernel locals math math.order sequences ;

TUPLE: point x y ;
C: <point> point
: >point< ( point -- x y ) [ x>> ] [ y>> ] bi ;

TUPLE: triangle p1 p2 p3 ;
C: <triangle> triangle
: >triangle< ( triangle -- x1 y1 x2 y2 x3 y3 )
    [ p1>> ] [ p2>> ] [ p3>> ] tri [ >point< ] tri@ ;

:: point-in-triangle? ( point triangle -- ? )
    point >point< triangle >triangle< :> ( x y x1 y1 x2 y2 x3 y3 )
    y2 y3 - x1 * x3 x2 - y1 * + x2 y3 * + y2 x3 * - :> d
    y3 y1 - x * x1 x3 - y * + x1 y3 * - y1 x3 * + d / :> t1
    y2 y1 - x * x1 x2 - y * + x1 y2 * - y1 x2 * + d neg / :> t2
    t1 t2 + :> s

    t1 t2 [ 0 1 between? ] bi@ and s 1 <= and ;

! Test if it works.

20 <iota> dup [ swap <point> ] cartesian-map                     ! Make a matrix of points
3 3 <point> 16 10 <point> 10 16 <point> <triangle>               ! Make a triangle
'[ [ _ point-in-triangle? "#" "." ? write ] each nl ] each nl    ! Show points inside the triangle with '#'
