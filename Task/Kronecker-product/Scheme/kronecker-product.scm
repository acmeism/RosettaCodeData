 (import srfi/231)

 (define (Kronecker-product A B)
   (let ((A (if (specialized-array? A) A (array-copy A)))
         (B (if (specialized-array? B) B (array-copy B))))
     (array-block! (array-map (lambda (a) (array-map (lambda (b) (* a b)) B)) A))))

 (pretty-print
  (array->list*
   (Kronecker-product
    (list*->array 2 '((1 2)
                      (3 4)))
    (list*->array 2 '((0 5)
                      (6 7))))))

 (newline)

 (pretty-print
  (array->list*
   (Kronecker-product
    (list*->array 2 '((0 1 0)
                      (1 1 1)
                      (0 1 0)))
    (list*->array 2 '((1 1 1 1)
                      (1 0 0 1)
                      (1 1 1 1))))))
