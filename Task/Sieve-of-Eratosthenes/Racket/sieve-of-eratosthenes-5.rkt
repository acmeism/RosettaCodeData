#lang racket

;; yet another variation of the same algorithm, this time using generators
(require racket/generator)

(define nats (generator () (for ([i (in-naturals 1)]) (yield i))))
(define (filter pred g)
  (generator () (for ([i (in-producer g #f)] #:when (pred i)) (yield i))))
(define (sift n g) (filter (λ(x) (not (zero? (modulo x n)))) g))
(define (sieve g)
  (generator ()
    (let loop ([g g]) (let ([x (g)]) (yield x) (loop (sift x g))))))
(define primes (begin (nats) (sieve nats)))

(define (take-upto n p)
  (let loop ()
    (let ([x (p)]) (if (<= x n) (cons x (loop)) '()))))
(take-upto 100 primes)
