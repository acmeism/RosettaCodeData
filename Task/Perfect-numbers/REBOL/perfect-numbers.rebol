perfect?:  func [n [integer!] /local sum] [
    sum: 0
    repeat i (n - 1) [
        if zero? remainder n i [
            sum: sum + i
        ]
    ]
    sum = n
]
