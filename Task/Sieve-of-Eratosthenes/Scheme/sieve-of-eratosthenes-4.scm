(define (primes-wheel-2 limit)
  (let ((stop (sqrt limit)))
    (define (sieve lst)
      (let ((p (car lst)))
        (if (> p stop)
            lst
            (cons p (sieve (strike (cdr lst) (* p p) (* 2 p)))))))
    (cons 2 (sieve (iota 3 limit 2)))))

(display (primes-wheel-2 100))
(newline)
