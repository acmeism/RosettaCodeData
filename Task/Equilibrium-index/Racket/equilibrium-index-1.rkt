#lang racket
(define (subsums xs)
  (for/fold ([sums '()] [sum 0]) ([x xs])
    (values (cons (+ x sum) sums)
            (+ x sum))))

(define (equivilibrium xs)
  (define-values (sums total) (subsums xs))
  (for/list ([sum (reverse sums)]
             [x xs]
             [i (in-naturals)]
             #:when (= (- sum x) (- total sum)))
    i))

(equivilibrium '(-7 1 5 2 -4 3 0))
