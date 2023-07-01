(lib 'sequences)

(define (a n) (+ n (floor (+ 0.5 (sqrt n)))))
(define A000037 (iterator/n a 1))

(take A000037 22)
    → (2 3 5 6 7 8 10 11 12 13 14 15 17 18 19 20 21 22 23 24 26 27)
(filter square? (take A000037 1000000))
    → null
