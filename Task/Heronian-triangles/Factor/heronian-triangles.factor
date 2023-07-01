USING: accessors assocs backtrack combinators.extras
combinators.short-circuit formatting io kernel locals math
math.functions math.order math.parser math.ranges mirrors qw
sequences sorting.slots ;
IN: rosetta-code.heronian-triangles

TUPLE: triangle a b c area perimeter ;

:: area ( a b c -- x )
    a b + c + 2 / :> s
    s s a - * s b - * s c - * sqrt ;

: <triangle> ( triplet-seq -- triangle )
    [ first3 ] [ first3 area >integer ] [ sum ] tri
    triangle boa ;

: heronian? ( a b c -- ? )
    area dup [ complex? ] [ 0 number= ] bi or
    [ drop f ] [ dup >integer number= ] if ;

: 3gcd ( a b c -- n ) [ gcd nip ] twice ;

: primitive-heronian? ( a b c -- ? )
    { [ 3gcd 1 = ] [ heronian? ] } 3&& ;

:: find-triangles ( -- seq )
    [
        200 [1,b] amb-lazy :> c    ! Use backtrack vocab to test
        c   [1,b] amb-lazy :> b    ! permutations of sides such
        b   [1,b] amb-lazy :> a    ! that c >= b >= a.
        a b c primitive-heronian? must-be-true
        { a b c } <triangle>
    ] bag-of ;                     ! collect every triangle

: sort-triangles ( seq -- seq' )
    { { area>> <=> } { perimeter>> <=> } } sort-by ;

CONSTANT: format "%4s%5s%5s%5s%10s\n"

: print-header ( -- )
    qw{ a b c area perimeter } format vprintf
    "---- ---- ---- ---- ---------" print ;

: print-triangle ( triangle -- )
    <mirror> >alist values [ number>string ] map format vprintf ;

: print-triangles ( seq -- ) [ print-triangle ] each ; inline

: first10 ( sorted-triangles -- )
    dup length "%d triangles found. First 10: \n" printf
    print-header 10 head print-triangles ;

: area210= ( sorted-triangles -- )
    "Triangles with area 210: " print print-header
    [ area>> 210 = ] filter print-triangles ;

: main ( -- )
    "Finding heronian triangles with sides <= 200..." print nl
    find-triangles sort-triangles
    [ first10 nl ] [ area210= ] bi ;

MAIN: main
