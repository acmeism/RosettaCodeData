Rebol [
    title: "Rosetta code: Jacobsthal numbers"
    file:  %Jacobsthal_numbers.r3
    url:   https://rosettacode.org/wiki/Jacobsthal_numbers
    note:  "Based on Red language solution"
]

jacobsthal: func [
    "Computes the nth Jacobsthal number via the formula"
    n [number!]
][
    2 ** n - (-1 ** n) / 3
]
lucas: func [
    "Computes the nth Lucas number."
    n [number!]
][
    2 ** n + (-1 ** n)
]
oblong: func [
    "Computes the product of Jacobsthal numbers for n and n+1"
    n [number!]
][
    multiply jacobsthal n jacobsthal n + 1
]

if unset? :prime? [
    ;; When native prime? function is not available...
    prime?: function [
        "Returns true if the input is a prime number"
        n [number!] "An integer to check for primality"
    ][
        if 2 = n [return true]
        if any [n <= 1 even? n] [return false]
        limit: square-root n
        candidate: 3
        while [candidate < limit][
            if n % candidate = 0 [return false]
            candidate: candidate + 2
        ]
        true
    ]
]

show: function [n fn][
    cols: 12
    repeat i n [
        prin [pad to integer! fn subtract i 1 cols]
        if i % 5 = 0 [prin newline]
    ]
    prin newline
]

print "First 30 Jacobsthal numbers:"
show 30 :jacobsthal

print "First 30 Jacobsthal-Lucas numbers:"
show 30 :lucas

print "First 20 Jacobsthal oblong numbers:"
show 20 :oblong

print "First 10 Jacobsthal primes:"
primes: n: 0
while [primes < 10][
    if prime? jacob: to integer! jacobsthal n [
        print jacob
        primes: primes + 1
    ]
    n: n + 1
]
