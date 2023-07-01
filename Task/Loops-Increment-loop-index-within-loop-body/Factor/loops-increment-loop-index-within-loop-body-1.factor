USING: formatting kernel math math.primes
tools.memory.private ;
IN: rosetta-code.loops-inc-body

42
0
[ dup 42 < ] [
    over prime? [
        1 + 2dup swap commas
        "n = %-2d  %19s\n" printf
        [ dup + 1 - ] dip
    ] when
    [ 1 + ] dip
] while
2drop
