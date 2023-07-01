#lang racket
(define ns (make-base-namespace))
(define (eval-with-x code a b)
  (define (with v) (eval `(let ([x ',v]) ,code) ns))
  (- (with b) (with a)))
