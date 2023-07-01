#lang racket

(define/match (compare i j)
  [((list x y) (list a b)) (or (< x a) (and (= x a) (< y b)))])

(define/match (key i)
  [((list x y)) (list (+ x y) (if (even? (+ x y)) (- y) y))])

(define (zigzag-ht n)
  (define indexorder
    (sort (for*/list ([x n] [y n]) (list x y))
          compare #:key key))
  (for/hash ([(n i) (in-indexed indexorder)]) (values n i)))

(define (zigzag n)
  (define ht (zigzag-ht n))
  (for/list ([x n])
    (for/list ([y n])
      (hash-ref ht (list x y)))))

(zigzag 4)
