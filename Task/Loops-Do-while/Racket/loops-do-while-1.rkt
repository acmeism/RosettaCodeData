#lang racket
(let loop ([n 0])
  (let ([n (add1 n)])
    (displayln n)
    (unless (zero? (modulo n 6)) (loop n))))
