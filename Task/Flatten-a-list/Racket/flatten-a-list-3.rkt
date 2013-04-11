#lang racket
(define (flatten l)
  (cond [(empty? l)      null]
        [(not (list? l)) (list l)]
        [else            (append (flatten (first l)) (flatten (rest l)))]))
(flatten '(1 (2 (3 4 5) (6 7)) 8 9))
