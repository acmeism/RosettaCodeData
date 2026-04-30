Rebol [
    title: "Rosetta code: Sieve of Eratosthenes"
    file:  %Sieve_of_Eratosthenes.r3
    url:   https://rosettacode.org/wiki/Sieve_of_Pritchard
    note:  "Translated from Red"
]

eratosthenes: function [
    "Eratosthenes sieve: finds all primes up to `limit` using a bitset-based sieve."
    limit [integer!]
][
    primes: copy []
    ;; Use a bitset as a boolean composite-marker array.
    ;; Index i is true if i has been marked as composite.
    prim: make bitset! limit
    prim/1: true ;; 1 is not prime, mark it as composite

    rtlim: to integer! square-root limit  ;; Only need primes up to sqrt(limit)

    ;; For each r starting at 2, mark all multiples of r as composite.
    ;; Only need to check up to sqrt(limit), since any composite above it
    ;; must have a prime factor at or below it.
    r: 2
    while [r <= rtlim][
        ;; Mark r*2, r*3, ..., r*floor(limit/r) as composite
        repeat q limit / r - 1 [
            prim/(q + 1 * r): true
        ]
        ;; Advance r to the next unmarked (prime) candidate
        until [not prim/(r: r + 1)]
    ]
    ;; Any index still unset in the bitset is prime.
    repeat i limit [
        unless prim/:i [append primes i]
    ]
    primes
]

probe eratosthenes 100
print rejoin ["Number of primes up to 1'000'000: " length? eratosthenes 1'000'000]
