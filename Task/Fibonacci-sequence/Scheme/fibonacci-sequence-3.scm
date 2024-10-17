(define (fib n)
  (let loop ((a 0) (b 1) (n n))
    (if (= n 0) a
        (loop b (+ a b) (- n 1)))))
