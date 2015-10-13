#lang racket
(require data/bit-vector)
;; Returns a list of prime numbers up to natural number limit
(define (eratosthenes limit)
  (define bv (make-bit-vector (+ limit 1) #f))
  (bit-vector-set! bv 0 #t)
  (bit-vector-set! bv 1 #t)
  (for* ([i (in-range (add1 (sqrt limit)))] #:unless (bit-vector-ref bv i)
         [j (in-range (* 2 i) (bit-vector-length bv) i)])
    (bit-vector-set! bv j #t))
  ;; translate to a list of primes
  (for/list ([i (bit-vector-length bv)] #:unless (bit-vector-ref bv i)) i))
(eratosthenes 100)
