USING: combinators formatting io kernel math math.primes
tools.memory.private ;

MEMO: motzkin ( m -- n )
    dup 2 < [
        drop 1
    ] [
        {
            [ 2 * 1 + ]
            [ 1 - motzkin * ]
            [ 3 * 3 - ]
            [ 2 - motzkin * + ]
            [ 2 + /i ]
        } cleave
    ] if ;

" n        motzkin(n)\n" print
42 [
    dup motzkin [ commas ] keep prime? "prime" "" ?
    "%2d %24s  %s\n" printf
] each-integer
