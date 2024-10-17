: fib ( n -- m )
    dup 2 < [
        [ 0 1 ] dip [ swap [ + ] keep ] times
        drop
    ] unless ;
