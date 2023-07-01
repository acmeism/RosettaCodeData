#lang racket/base
(define (sum lo hi f)
  (for/sum ([i (in-range lo (add1 hi))]) (f i)))
(sum 1 100 (λ(i) (/ 1.0 i)))
