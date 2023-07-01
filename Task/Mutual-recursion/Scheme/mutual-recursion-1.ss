(define (F n)
  (if (= n 0) 1
      (- n (M (F (- n 1))))))

(define (M n)
  (if (= n 0) 0
      (- n (F (M (- n 1))))))
