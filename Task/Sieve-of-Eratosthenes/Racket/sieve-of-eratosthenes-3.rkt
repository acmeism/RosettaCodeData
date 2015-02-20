#lang racket
(require data/bit-vector)
(define (eratosthenes limit)
  " Returns a list of prime numbers up to natural number limit "
  (let ((bv (make-bit-vector (+ limit 1) #f)))
    (bit-vector-set! bv 0 #t)
    (bit-vector-set! bv 1 #t)
    (for ((i (in-range (sqrt limit))))
      (when (false? (bit-vector-ref bv i))
        (for ((j (in-range (+ i i) (bit-vector-length bv) i)))
          (bit-vector-set! bv j #t))))
    ;; Translate bit-vector into list of primes
    ;; the following is extremely ugly/imperative and needs the result list reversed
    (let ((to-return null))
      (for ((i (bit-vector-length bv)))
        (when (not (bit-vector-ref bv i)) (set! to-return (cons i to-return))))
      (reverse to-return)))) ; NOTE: needs to be reversed
