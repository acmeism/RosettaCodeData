#lang racket
(define-syntax-rule (while condition body ...)
  (let loop ()
    (when condition
      body ...
      (loop))))

(define n 1024)
(while (positive? n)
  (displayln n)
  (set! n (sub1 n)))
