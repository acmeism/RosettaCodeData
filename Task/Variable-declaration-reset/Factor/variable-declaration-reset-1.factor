USING: kernel math prettyprint sequences ;

[let
    { 1 2 2 3 4 4 5 } :> s
    s length <iota> [| i |
        i s nth -1 :> ( curr prev! )
        i 0 > curr prev = and
        [ i . ] when
        curr prev!
    ] each
]
