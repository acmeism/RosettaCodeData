#lang racket/base

(require math/number-theory
         math/base)

gamma.0

;; if you want to work it out the hard way...
(define (H n)
  (for/sum ((i n)) (/ (add1 i))))

(define (g #:n (n 10) #:k (k 7))
  (+ (- (H n)
        (log n)
        (/ (* n 2)))
     (for/sum ((2k (in-range 2 (* 2 (add1 k)) 2)))
       (/ (bernoulli-number 2k) (* (expt n 2k) 2k)))))

(g)
