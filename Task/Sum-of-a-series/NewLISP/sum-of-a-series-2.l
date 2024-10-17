(define (sm n (s 0))
  (if (zero? n) s (sm (- n 1) (add s (div 1 n n)))))

(sm 1000)

1.64393456668156
