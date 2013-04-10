#lang racket

(define (accumulator n)
    (lambda (i)
      (set! n (+ n i))
      n))
