(define (make-identity-matrix n)
   (map (lambda (i)
         (append (repeat 0 i) '(1) (repeat 0 (- n i 1))))
      (iota n)))

(for-each print (make-identity-matrix 3))
(for-each print (make-identity-matrix 17))
