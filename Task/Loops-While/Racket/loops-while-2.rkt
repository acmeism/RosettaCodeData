#lang racket
(define-syntax-rule (while condition body ...)
  (let loop ()
    (when condition
      body ...
      (loop))))

(define n 0)
(while (< n 10)
  (displayln n)
  (set! n (add1 n)))
