#lang racket
(define ns (make-base-namespace))
(define (eval-with-x code a b)
  (define (with v)
    (namespace-set-variable-value! 'x v #f ns)
    (eval code ns))
  (- (with b) (with a)))
