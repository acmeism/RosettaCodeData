(define a #(1 3 -5))
(define b #(4 -2 -1))

;; function definition
(define ( ⊗ a b) (for/sum ((x a)(y b)) (* x y)))
(⊗ a b) → 3

;; library
(lib 'math)
(dot-product a b) → 3
