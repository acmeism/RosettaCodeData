(define (sum a b fn)
  (do ((i a (+ i 1))
       (result 0 (+ result (fn i))))
      ((> i b) result)))

(sum 1 1000 (lambda (x) (/ 1 (* x x)))) ; fraction
(exact->inexact (sum 1 1000 (lambda (x) (/ 1 (* x x))))) ; decimal
