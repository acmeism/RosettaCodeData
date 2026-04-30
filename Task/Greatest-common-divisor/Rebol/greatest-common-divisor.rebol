gcd: func [
    {Returns the greatest common divisor of m and n.}
    m [integer!]
    n [integer!]
    /local k
] [
    ; Euclid's algorithm
    while [n > 0] [
        k: m
        m: n
        n: k // m
    ]
    m
]
