#lang racket

(require math/matrix)

(define (fibmat n) (matrix-ref
                    (matrix-expt (matrix ([1 1]
                                          [1 0]))
                                 n)
                    1 0))

(fibmat 1000)
