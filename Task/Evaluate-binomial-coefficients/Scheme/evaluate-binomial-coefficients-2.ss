(define (pascal i j)
  (cond ((= i 0) 1)
        ((= j 0) 1)
        (else (+
               (pascal (- i 1) j)
               (pascal i (- j 1))))))

(define (choose n k)
  (pascal (- n k) k)))

(display (choose 5 3))
(newline)
