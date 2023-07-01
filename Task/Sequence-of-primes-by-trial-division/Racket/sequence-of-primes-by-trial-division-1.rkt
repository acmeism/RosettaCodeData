#lang lazy
(define nats (cons 1 (map add1 nats)))
(define (sift n l) (filter (λ(x) (not (zero? (modulo x n)))) l))
(define (sieve l) (cons (first l) (sieve (sift (first l) (rest l)))))
(define primes (sieve (rest nats)))
(!! (take 25 primes))
