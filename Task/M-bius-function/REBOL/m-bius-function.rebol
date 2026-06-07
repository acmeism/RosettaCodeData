Rebol [
    title: "Rosetta code: Möbius function"
    file:  %Möbius_function.r3
    url:   https://rosettacode.org/wiki/Möbius_function
]

mobius: function [
    {Returns a Möbius function vector of length limit
     MU[n] = 1 if n is square-free with even prime factors,
            -1 if n is square-free with odd prime factors,
             0 if n has a squared prime factor.}
    limit [integer!] "upper bound of the sieve"
][
    MU: append/dup #(int32! []) 1 limit  ;; all ones: assume square-free, even factors

    for i 2 square-root limit 1 [
        if MU/:i == 1 [                  ;; i is prime (untouched by earlier steps)
            ni: negate i
            for j i limit i [
                MU/:j: MU/:j * ni        ;; flip sign for each multiple of prime i
            ]
            ii: i * i
            for j ii limit ii [
                MU/:j: 0                 ;; zero out multiples of i² (not square-free)
            ]
        ]
    ]
    for i 2 limit 1 [
        v: MU/:i
        MU/:i: case [
            v = i        [ 1]            ;; product of primes collapsed to +1
            v = negate i [-1]            ;; product of primes collapsed to -1
            v < 0        [ 1]            ;; negative even count -> +1
            v > 0        [-1]            ;; positive odd count  -> -1
            'else        [ v]            ;; zero: already correct
        ]
    ]
    MU
]

mu: mobius 1'000'000

print "first 199 terms of the mobius sequence:"
prin "   "
repeat n 199 [
    if zero? n % 20 [ print "" ]  ;; newline every 20 terms
    prin pad mu/:n -3
]
print ""
