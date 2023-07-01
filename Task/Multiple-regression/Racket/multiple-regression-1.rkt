#lang racket
(require math)
(define T matrix-transpose)

(define (fit X y)
  (matrix-solve (matrix* (T X) X) (matrix* (T X) y)))
