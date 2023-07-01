#lang racket

(require math/number-theory
         racket/generator)

(define (make-generator start)
  (in-generator
   (for ([n (in-naturals start)] #:when (odd? n))
     (define divisor-sum (- (apply + (divisors n)) n))
     (when (> divisor-sum n) (yield (list n divisor-sum))))))

(for/list ([i (in-range 25)] [x (make-generator 0)]) x) ; Task 1
(for/last ([i (in-range 1000)] [x (make-generator 0)]) x) ; Task 2
(for/first ([x (make-generator (add1 (inexact->exact 1e9)))]) x) ; Task 3
