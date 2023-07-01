#lang racket
(define n 0)
(let loop ()
  (set! n (add1 n))
  (displayln n)
  (unless (zero? (modulo n 6)) (loop)))
