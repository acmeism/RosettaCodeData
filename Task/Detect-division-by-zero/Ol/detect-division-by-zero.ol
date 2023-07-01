(define (safediv a b)
   (if (eq? (type b) type-complex)
      (/ a b) ; complex can't be 0
      (let ((z (/ 1 (inexact b))))
         (unless (or (equal? z +inf.0) (equal? z -inf.0))
            (/ a b)))))

; testing:
(for-each (lambda (x)
      (if x (print x) (print "division by zero detected")))
   (list
      (safediv 1 5)    ; => 1/5
      (safediv 2 0)    ; => division by zero detected
      (safediv 3 1+2i) ; => 3/5-6/5i
      (safediv 4 0+i)  ; => 0-4i
      (safediv 5 7/5)  ; => 25/7
))
