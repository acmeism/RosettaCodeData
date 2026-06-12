USING: io kernel locals math math.functions math.order
prettyprint sequences ;

:: (root) ( a b -- n )
    a 1 - 1 :> ( a1 c! )
    [| x | a1 x * b x a1 ^ /i + a /i ] :> f
    c f call :> d!
    d f call :> e!
    [ c { d e } member? ] [
        d c! e d! e f call e!
    ] until
    d e min ;

: root ( a b -- n ) dup 2 < [ nip ] [ (root) ] if ;

"First 2,001 digits of the square root of two:" print
2 100 2000 ^ 2 * root .
