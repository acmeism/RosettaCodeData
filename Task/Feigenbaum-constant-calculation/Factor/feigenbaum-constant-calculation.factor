USING: formatting io locals math math.ranges sequences ;

[let
      1 :> a1!
      0 :> a2!
    3.2 :> d!

    " i d" print

    2 13 [a,b] [| exp |
        a1 a2 - d /f a1 + :> a!
        10 [
            0 :> x!
            0 :> y!
            exp 2^ [
                1 2 x y * * - y!
                a x sq - x!
            ] times
            a x y /f - a!
        ] times
        a1 a2 - a a1 - /f d!
        a1 a2! a a1!
        exp d "%2d %.8f\n" printf
    ] each
]
