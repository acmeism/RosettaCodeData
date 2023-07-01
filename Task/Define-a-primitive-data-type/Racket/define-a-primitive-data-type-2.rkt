#lang typed/racket

(define-type 1UpTo10 (U 1 2 3 4 5 6 7 8 9 10))

;; type-checks
(: x 1UpTo10)
(define x 3)

;; does not type-check
(: y 1UpTo10)
(define y 18)
