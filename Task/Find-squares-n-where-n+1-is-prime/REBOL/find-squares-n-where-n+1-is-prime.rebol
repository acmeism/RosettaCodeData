Rebol [
    title: "Rosetta code: Find squares n where n+1 is prime"
    file:  %Find_squares_n_where_n+1_is_prime.r3
    url:   https://rosettacode.org/wiki/Find_squares_n_where_n%2B1_is_prime
]

results: collect [
    i: 1
    while [1000 > n: i * i][
        if prime? n + 1 [keep n]
        ++ i
    ]
]

print ["Squares n where n+1 is prime and n < 1000:" as-green results]
