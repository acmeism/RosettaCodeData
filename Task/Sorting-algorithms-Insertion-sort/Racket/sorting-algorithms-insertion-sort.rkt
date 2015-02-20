#lang racket

(define (sort < l)
  (define (insert x y)
    (match* (x y)
      [(x '()) (list x)]
      [(x (cons y ys)) (cond [(< x y) (list* x y ys)]
                             [else (cons y (insert x ys))])]))
  (foldl insert '() l))
