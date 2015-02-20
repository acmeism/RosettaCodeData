#lang racket

(define (sieve n)
  (define primes (make-vector (add1 n) #t))
  (for* ([i (in-range 2 (add1 n))]
         #:when (vector-ref primes i)
         [j (in-range (* i i) (add1 n) i)])
    (vector-set! primes j #f))
  (for/list ([n (in-range 2 (add1 n))]
             #:when (vector-ref primes n))
    n))

(sieve 100)
