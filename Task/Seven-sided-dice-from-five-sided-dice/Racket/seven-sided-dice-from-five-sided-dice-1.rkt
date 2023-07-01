#lang racket
(define (dice5) (add1 (random 5)))

(define (dice7)
  (define res (+ (* 5 (dice5)) (dice5) -6))
  (if (< res 21) (+ 1 (modulo res 7)) (dice7)))
