#lang racket

(define (sieve n)
  (define non-primes '())
  (define primes '())
  (for ([i (in-range 2 (add1 n))])
    (unless (member i non-primes)
      (set! primes (cons i primes))
      (for ([j (in-range (* i i) (add1 n) i)])
        (set! non-primes (cons j non-primes)))))
  (reverse primes))

(sieve 100)
