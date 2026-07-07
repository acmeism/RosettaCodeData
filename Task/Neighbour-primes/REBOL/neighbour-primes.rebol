Rebol [
    title: "Rosetta code: Neighbour primes"
    file:  %Neighbour_primes.r3
    url:   https://rosettacode.org/wiki/Neighbour_primes
]

primes-up-to-500: collect [
    repeat i 500 [if prime? i [keep i]]
]

print "p       q       p*q+2"
print "------------------------"
forall primes-up-to-500 [
    set [p q] primes-up-to-500
    if all [q prime? (pq+2: p * q + 2)] [
        printf [8 8 ][p q pq+2]
    ]
]
