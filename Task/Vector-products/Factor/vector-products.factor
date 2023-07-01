USING: arrays io locals math prettyprint sequences ;

: dot-product ( a b -- dp ) [ * ] 2map sum ;

:: cross-product ( a b -- cp )
    a first :> a1 a second :> a2 a third :> a3
    b first :> b1 b second :> b2 b third :> b3
    a2 b3 * a3 b2 * - ! X
    a3 b1 * a1 b3 * - ! Y
    a1 b2 * a2 b1 * - ! Z
    3array ;

: scalar-triple-product ( a b c -- stp )
    cross-product dot-product ;

: vector-triple-product ( a b c -- vtp )
    cross-product cross-product ;

[let
    { 3 4 5 }      :> a
    { 4 3 5 }      :> b
    { -5 -12 -13 } :> c
    "a: " write a .
    "b: " write b .
    "c: " write c . nl
    "a . b: " write a b dot-product .
    "a x b: " write a b cross-product .
    "a . (b x c): " write a b c scalar-triple-product .
    "a x (b x c): " write a b c vector-triple-product .
]
