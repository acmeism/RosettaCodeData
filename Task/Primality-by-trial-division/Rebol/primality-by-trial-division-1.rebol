prime?: func [n] [
    case [
        n = 2 [ true  ]
        n <= 1 or (n // 2 = 0) [ false ]
        true [
            for i 3 round square-root n 2 [
                if n // i = 0 [ return false ]
            ]
            true
        ]
    ]
]
