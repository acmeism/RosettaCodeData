USING: formatting kernel math math.primes math.ranges sequences
tools.memory.private ;

[let
    199 :> limit
    1 limit 2 <range> [| n |
        n n n * * 2 + :> p
        p prime?
        [ n p commas "n = %3d => n³ + 2 = %9s\n" printf ] when
    ] each
]
