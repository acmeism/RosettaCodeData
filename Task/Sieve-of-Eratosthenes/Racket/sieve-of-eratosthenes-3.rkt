#lang lazy

;; infinite list using lazy racket (see the language above)
(define nats (cons 1 (map add1 nats)))
(define (sift n l) (filter (λ(x) (not (zero? (modulo x n)))) l))
(define (sieve l) (cons (first l) (sieve (sift (first l) (rest l)))))
(define primes (sieve (rest nats)))

(define (take-upto n l)
  (if (<= (car l) n) (cons (car l) (take-upto n (cdr l))) '()))
(!! (take-upto 100 primes))
