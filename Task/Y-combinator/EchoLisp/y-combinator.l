;; Ref : http://www.ece.uc.edu/~franco/C511/html/Scheme/ycomb.html

 (define Y
    (lambda (X)
      ((lambda (procedure)
         (X (lambda (arg) ((procedure procedure) arg))))
       (lambda (procedure)
         (X (lambda (arg) ((procedure procedure) arg)))))))

; Fib
(define Fib* (lambda (func-arg)
    (lambda (n) (if (< n 2) n (+ (func-arg (- n 1)) (func-arg (- n 2)))))))
(define fib (Y Fib*))
(fib 6)
    → 8

; Fact
(define F*
   (lambda (func-arg) (lambda (n) (if (zero? n) 1 (* n (func-arg (- n 1)))))))
(define fact (Y F*))

(fact 10)
    → 3628800
