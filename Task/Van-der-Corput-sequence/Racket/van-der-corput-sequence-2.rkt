#lang racket
(define (digit-length n base)
  (if (< n base) 1 (add1 (digit-length (quotient n base) base))))
(define (digit n i base)
  (remainder (quotient n (expt base i)) base))
(define (van-der-Corput n base)
  (for/sum ([i (digit-length n base)]) (/ (digit n i base) (expt base (+ i 1)))))
