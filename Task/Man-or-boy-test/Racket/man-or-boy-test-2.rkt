#lang racket

(define (A k x1 x2 x3 x4 x5)
  (if (<= k 0)
      (+ (x4) (x5))
      (let B ()
        (set! k (- k 1))
        (A k B x1 x2 x3 x4))))

(A 10 (lambda () 1) (lambda () -1) (lambda () -1) (lambda () 1) (lambda () 0))
