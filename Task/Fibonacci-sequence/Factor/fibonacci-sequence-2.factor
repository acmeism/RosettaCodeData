: fib ( n -- m )
    dup 2 < [
        [ 1 - fib ] [ 2 - fib ] bi +
    ] unless ;
