(define (sieve l non-primes)
  (let ([x (car l)] [np (car non-primes)])
    (cond [(= x np)     (sieve (cdr l) (cdr  non-primes))]    ; else x < np
          [else (cons x (sieve (cdr l) (union (ints-from (* x x) (* 2 x))
                                               non-primes)))])))
(define primes (cons 2 (cons 3 (sieve (ints-from 5 2) (ints-from 9 6)))))
