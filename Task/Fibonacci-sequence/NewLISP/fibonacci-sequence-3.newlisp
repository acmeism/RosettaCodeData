(define (fibonacci n)
  (letn (f '((0 1) (1 1)) fib f)
    (dotimes (i n)
        (set 'fib (multiply fib f)))
    (fib 0 1)) )

(print(fibonacci 10)) ;;89
