(define (fib n (a 0) (b 1))
  (if (< n 2)
      1
      (+ a (fib (- n 1) b (+ a b)))))
