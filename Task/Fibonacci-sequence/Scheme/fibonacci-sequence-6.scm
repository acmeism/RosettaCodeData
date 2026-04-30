(define (fast-fib-pair n)
  ;; By Arnold Schönhage, personal communication, 2004
  ;; returns f_n f_{n+1}
  (case n
    ((1) (values 1 1))
    ((2) (values 1 2))
    (else
     (let ((m (quotient n 2)))
       (call-with-values
           (lambda () (fast-fib-pair m))
         (lambda (f_m f_m+1)
           (let ((f_m^2   (square f_m))
                 (f_m+1^2 (square f_m+1)))
             (if (even? n)
                 (values (- (* 2 f_m+1^2)
                            (* 3 f_m^2)
                            (if (odd? m) -2 2))
                         (+ f_m^2 f_m+1^2))
                 (values (+ f_m^2 f_m+1^2)
                         (- (* 3 f_m+1^2)
                            (* 2 f_m^2)
                            (if (odd? m) -2 2)))))))))))

(call-with-values
    (lambda ()
      (fast-fib-pair 100000000))
  (lambda (f_n f_n+1)
    (display (list (modulo f_n 100000) (modulo f_n+1 100000)))
    (newline)))
