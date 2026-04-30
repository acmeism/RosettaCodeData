factors: function [n [integer!]] [
    n: absolute n                          ;; work with a non-negative value for factorization
    collect [                              ;; build and return a block of factors
        repeat i (sq: square-root n) - 1 [ ;; test divisors from 1 up to floor(sqrt(n)) - 1
            if n % i = 0 [                 ;; if i divides n
                keep i                     ;; keep the small factor i
                keep n / i                 ;; and its complementary factor n/i
            ]
        ]
        ;; If n is a perfect square, include the square root once (to avoid duplication)
        if sq = sq: to integer! sq [keep sq]
    ]
]
