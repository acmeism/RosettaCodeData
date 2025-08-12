ackermann: func [
    m [integer!]
    n [integer!]
] [
    ;; Small-m closed forms
    case [
        m = 0 [n + 1]
        m = 1 [n + 2]
        m = 2 [(2 * n) + 3]
        m = 3 [
            ;; 2^(n+3) - 3
            (to integer! power 2 (n + 3)) - 3
        ]
        ;; m >= 4 causes stack overflow
    ]
]
