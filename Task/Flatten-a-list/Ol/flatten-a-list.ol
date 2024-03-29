(define (flatten x)
   (cond
      ((null? x)
         '())
      ((not (pair? x))
         (list x))
      (else
         (append (flatten (car x))
                 (flatten (cdr x))))))

(print
   (flatten '((1) 2 ((3 4) 5) ((())) (((6))) 7 8 ())))
