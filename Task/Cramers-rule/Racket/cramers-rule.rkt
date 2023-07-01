#lang racket
(require math/matrix)

(define sys
  (matrix [[2 -1 5 1]
           [3 2 2 -6]
           [1 3 3 -1]
           [5 -2 -3 3]]))

(define soln
  (col-matrix [-3 -32 -47 49]))

(define (matrix-set-column M new-col idx)
  (matrix-augment (list-set (matrix-cols M) idx new-col)))

(define (cramers-rule M soln)
  (let ([denom (matrix-determinant M)]
        [nvars (matrix-num-cols M)])
    (letrec ([roots (λ (position)
                      (if (>= position nvars)
                          '()
                          (cons (/ (matrix-determinant
                                    (matrix-set-column M soln position))
                                   denom)
                                (roots (add1 position)))))])
      (map cons '(w x y z) (roots 0)))))

(cramers-rule sys soln)
