(define (sieve l non-primes)
  (let ([x (car l)] [np (car non-primes)])
    (cond [(= x np)     (sieve (cdr l) (cdr  non-primes))]    ; else x < np
          [else (cons x (sieve (cdr l) (union (ints-from (* x x) x)
                                               non-primes)))])))
(define primes (cons 2 (sieve (ints-from 3 1) (ints-from 4 2))))
