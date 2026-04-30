(import (srfi 231))

(define (matrix-multiply A B)
  (array-inner-product A + * B))

(pretty-print
 (array->list*
  (matrix-multiply
   (list*->array 2 '((1 2)
                     (3 4)))
   (list*->array 2 '((-3 8 3)
                     (-2 1 4))))))
