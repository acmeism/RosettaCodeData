(lib 'list)
(lib 'matrix)

;; adapted from Racket
(define (permanent M)
    (let (( n (matrix-row-num M)))
    (for/sum ([σ (in-permutations n)])
        (for/product ([i n] [σi σ])
            (array-ref M i σi)))))

;; output
(define A (list->array '(1 2 3 4) 2 2))
(array-print A)
  1  2
  3  4
(determinant A) → -2
(permanent A) → 10

(define M (list->array (iota 25) 5 5))
(array-print M)
   0   1   2   3   4
   5   6   7   8   9
  10  11  12  13  14
  15  16  17  18  19
  20  21  22  23  24
(determinant M) → 0
(permanent M) → 6778800
