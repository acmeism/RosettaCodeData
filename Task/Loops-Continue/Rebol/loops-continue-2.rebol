repeat i 10 [
    prin i
    if zero? i % 5 [
        prin newline
        continue
    ]
    prin ", "
]
