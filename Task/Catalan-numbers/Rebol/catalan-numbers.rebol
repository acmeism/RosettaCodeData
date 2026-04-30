Rebol [
    title: "Rosetta code: Catalan numbers"
    file:  %Catalan_numbers.r3
    url:   https://rosettacode.org/wiki/Catalan_numbers
]

catalan: func [
    "Compute the nth Catalan number recursively"
    n [integer!]
][
    either zero? n [1][
        (catalan n - 1) * (4 * n - 2) / (n + 1)
    ]
]

for n 0 15 1 [
    print [
        pad n 5
        pad catalan n -20
    ]
]
