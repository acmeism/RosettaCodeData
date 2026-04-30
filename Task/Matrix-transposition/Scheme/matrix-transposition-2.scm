(import srfi/231)

(define (transpose m)
  (array-permute m '#(1 0)))

(define m
  (list->array (make-interval '#(3 8))
               (iota 24)))

(define m*
  (transpose m))

(pretty-print (array->list* m))
(newline)
(pretty-print (array->list* m*))
