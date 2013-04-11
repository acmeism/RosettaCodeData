#lang racket
(let loop ([n 0])
  (set! n (+ n 1))
  (displayln n)
  (unless (zero? (remainder n 6))
    (loop n)))
