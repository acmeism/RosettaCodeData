(define Y
  (lambda (h)
    ((lambda (x) (x x))
     (lambda (g)
       (h (lambda args (apply (g g) args)))))))

;; head-recursive factorial
(define fac
  (Y
    (lambda (f)
      (lambda (x)
        (if (< x 2)
            1
            (* x (f (- x 1))))))))

;; tail-recursive factorial
(define (fac2 n)
  (letrec ((tail-fac
             (Y (lambda (f)
                  (lambda (n acc)
                    (if (zero? n)
                        acc
                        (f (- n 1) (* n acc))))))))
    (tail-fac n 1)))

(define fib
  (Y
    (lambda (f)
      (lambda (x)
        (if (< x 2)
            x
            (+ (f (- x 1)) (f (- x 2))))))))

(display (fac 6))
(newline)

(display (fib 6))
(newline)
