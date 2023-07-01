#lang racket
(define (fold f xs init)
  (if (empty? xs)
      init
      (f (first xs)
         (fold f (rest xs) init))))

(fold + '(1 2 3) 0)   ; the result is 6
