#lang racket

(define (sort < l)
  (define (insert x ys)
    (match ys
      [(list) (list x)]
      [(cons y rst) (cond [(< x y) (cons x ys)]
                          [else (cons y (insert x rst))])]))
  (foldl insert '() l))
