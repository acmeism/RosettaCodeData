USING: formatting kernel locals make math sequences ;

:: fib<= ( n -- seq )
    1 2 [ [ dup n <= ] [ 2dup + [ , ] 2dip ] while drop , ]
    { } make ;

:: zeck ( n -- str )
    0 :> s! n fib<= <reversed>
    [ dup s + n <= [ s + s! 49 ] [ drop 48 ] if ] "" map-as ;

21 <iota> [ dup zeck "%2d: %6s\n" printf ] each
