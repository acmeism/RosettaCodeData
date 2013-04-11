USE: math.matrices

: fib ( n -- m )
    dup 2 < [
        [ { { 0 1 } { 1 1 } } ] dip 1 - m^n
        second second
    ] unless ;
