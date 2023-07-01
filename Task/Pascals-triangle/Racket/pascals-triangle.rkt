#lang racket

(define (pascal n)
  (define (next-row current-row)
    (map + (cons 0 current-row)
           (append current-row '(0))))
  (reverse
   (for/fold ([triangle '((1))])
             ([row (in-range 1 n)])
     (cons (next-row (first triangle)) triangle))))
