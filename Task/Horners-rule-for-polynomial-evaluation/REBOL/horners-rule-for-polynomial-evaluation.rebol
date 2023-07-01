REBOL []

horner: func [coeffs x] [
    result: 0
    foreach i reverse coeffs [
        result: (result * x) + i
        ]
    return result
    ]

print horner [-19 7 -4 6] 3
