(lib 'matrix)

(define M (list->array (iota 6) 3 2))
(array-print M)
  0   1
  2   3
  4   5
(array-print (matrix-transpose M))
  0   2   4
  1   3   5
