(define (fib n)
  (car (foldl (lambda (y x)
                (let ((a (car x)) (b (cdr x)))
                  (cons b (+ a b)))) (cons 0 1) (range n))))
