Rebol [
    title: "Rosetta code: Find prime n such that reversed n is also prime"
    file:  %Find_prime_n_such_that_reversed_n_is_also_prime.r3
    url:   https://rosettacode.org/wiki/Find_prime_n_such_that_reversed_n_is_also_prime
]
print collect [
    repeat n 499 [
        if all [
            prime? n
            prime? to integer! reverse form n
        ][  keep n ]
    ]
]
