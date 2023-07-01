USING: formatting kernel math math.primes
tools.memory.private ;
IN: rosetta-code.loops-inc-body

[let
    42 :> i!
    0  :> n!
    [ n 42 < ] [
        i prime? [
            n 1 + n!
            n i commas "n = %-2d  %19s\n" printf
            i i + 1 - i!
        ] when
        i 1 + i!
    ] while
]
