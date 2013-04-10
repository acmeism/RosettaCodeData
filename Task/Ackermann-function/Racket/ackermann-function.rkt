#lang racket
(define (ackermann m n)
  (cond [(zero? m) (add1 n)]
        [(and (> m 0) (zero? n))
         (ackermann (sub1 m) 1)]
        [(and (> m 0) (> n 0))
         (ackermann (sub1 m) (ackermann m (sub1 n)))]))
