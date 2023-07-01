#lang racket

(require math/matrix
         math/array)

(define (inverse M)
  (define dim (square-matrix-size M))
  (define MI (matrix-augment (list M (identity-matrix dim))))
  (submatrix (matrix-row-echelon MI #t #t) (::) (:: dim  #f)))

(define A (matrix [[1 2 3] [4 1 6] [7 8 9]]))

(inverse A)
(matrix-inverse A)
