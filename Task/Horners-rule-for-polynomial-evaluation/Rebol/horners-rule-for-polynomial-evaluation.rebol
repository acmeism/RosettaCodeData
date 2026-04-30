Rebol []

horner: func [coeffs x] [
    result: 0
    foreach i reverse coeffs [
        result: (result * x) + i
    ]
]

print horner [-19 7 -4 6] 3
;== 128
