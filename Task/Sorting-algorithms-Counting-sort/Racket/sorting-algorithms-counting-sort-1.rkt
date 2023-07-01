#lang racket

(define (counting-sort xs min max)
  (define ns (make-vector (+ max (- min) 1) 0))
  (for ([x xs])  (vector-set! ns (- x min) (+ (vector-ref ns (- x min)) 1)))
  (for/fold ([i 0]) ([n ns] [x (in-naturals)])
    (for ([j (in-range i (+ i n ))])
      (vector-set! xs j (+ x min)))
    (+ i n))
  xs)

(counting-sort (vector 0 9 3 8 1 -1 1 2 3 7 4) -1 10)
