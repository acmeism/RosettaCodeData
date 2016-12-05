#lang racket
(require math)

(define (perfect? n)
  (=
   (* n 2)
   (sum (divisors n))))

; filtering to only even numbers for better performance
(filter perfect? (filter even? (range 1e5)))
;-> '(0 6 28 496 8128)
