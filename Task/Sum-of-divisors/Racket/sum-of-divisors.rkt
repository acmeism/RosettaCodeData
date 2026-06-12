#lang racket/base

(require math/number-theory)

(define (sum-of-divisors n) (apply + (divisors n)))

(displayln (for/list ((n (in-range 1 101))) (sum-of-divisors n)))
