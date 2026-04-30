ackermann: func [m n] [
    case [
        m = 0 [n + 1]
        n = 0 [ackermann m - 1 1]
        true [ackermann m - 1 ackermann m n - 1]
    ]
]
