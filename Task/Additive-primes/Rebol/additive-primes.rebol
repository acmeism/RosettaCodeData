Rebol [
    title: "Rosetta code: Additive primes"
    file:  %Additive_primes.r3
    url:   https://rosettacode.org/wiki/Additive_primes
    note:  "Based on Red language solution"
]
primes: function [n [integer!]][
    ;; See: https://rosettacode.org/wiki/Sieve_of_Eratosthenes#Rebol
    poke prim: make bitset! n 1 true
    r: 2 while [r * r <= n][repeat q n / r - 1 [poke prim q + 1 * r true]
    until [not pick prim r: r + 1]]
    collect [repeat i n [unless prim/:i [keep i]]]
]
;; Compute the digit sum (cross-sum) of an integer n
cross-sum: function [n][
    out: 0                 ;; accumulator for sum of digits
    foreach m form n [     ;; iterate over the characters of n's string form
        out: out - 48 + m  ;; convert char to integer, add to out
    ]
    out
]
;; Return all additive primes <= n:
;; A prime p is "additive" if its digit-sum is also prime.
additive-primes: function [n][
    collect [
        foreach p ps: primes n [       ;; generate primes up to n and iterate over them
            if find ps cross-sum p [   ;; check if digit-sum of p is itself in the prime set
                keep p                 ;; keep p if digit-sum is prime
            ]
        ]
    ]
]

;; Generate additive primes up to 500
result: additive-primes 500
;; Format nicely by rows of 10 (with newlines)
print [length? result "additive primes < 500:"]
forall result [
    prin pad result/1 -4
    if zero? ((index? result) % 10) [print ""]
]
print ""
