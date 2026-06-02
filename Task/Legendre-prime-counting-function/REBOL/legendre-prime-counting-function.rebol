Rebol [
    title: "Rosetta code: Legendre prime counting function"
    file:  %Legendre_prime_counting_function.r3
    url:   https://rosettacode.org/wiki/Legendre_prime_counting_function
]

legendre-pi-count: function/with [
    "Count primes up to n using Legendre's phi formula"
    n [number!]
][
    if n == 0 [return 0]
    if n == 2 [return 1]

    primes: primes-up-to square-root n
    prime-count: length? primes
    result: (phi n prime-count) + prime-count - 1
][
    primes: sieve: _                         ;; shared state across calls
    cache: make map! 100000                  ;; phi memoization table

    prime-sieve: function [
        ;; Returns a bitset where bit i is true if i is prime
        sieve-size [integer!]
    ][
        sieve: make bitset! sieve-size
        repeat i sieve-size - 1 [sieve/:i: true]
        sieve/1: false                       ;; 1 is not prime

        repeat s-pos sieve-size [
            if sieve/:s-pos [
                p: s-pos * s-pos             ;; start crossing off at p^2
                while [p <= sieve-size] [
                    sieve/:p: false
                    p: p + s-pos
                ]
            ]
        ]
        sieve
    ]

    sieve: prime-sieve to integer! sqrt 1e9  ;; one-time sieve up to sqrt(10^9)

    primes-up-to: function [
        ;; Extract list of primes from sieve up to n
        n [number!]
    ][
        out: clear []
        repeat i n [ if sieve/:i [append out i] ]
        out
    ]

    phi: function [
        ;; Legendre's phi: count integers <= x not divisible by first a primes
        x a
    ][
        key: as-pair x a                     ;; pack (x, a) into a pair! for cache lookup
        unless result: cache/:key [
            sum: 0
            while [a > 1] [
                either x <= pa: primes/:a [
                    done?: true              ;; x has no more factors to sieve
                    break
                ][
                    -- a
                    sum: sum + phi x // pa a
                ]
            ]
            result: either done? [1] [x - sum - (x // 2)]
            cache/:key: result               ;; memoize before returning
        ]
        result
    ]
]

start: stats/timer
for exp 0 9 1 [
    print ajoin ["π(10**" exp ") = " legendre-pi-count 10 ** exp]
]
print ["This took" stats/timer - start]
