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
      ;; Translate bit-vector into list of primes using recursion
      ;; may as well use the list comprehension from the second version, which does the same thing
      (let recur ((i 2)) (cond ((> i limit) '())
                               ((false? (bit-vector-ref bv i)) (cons i (recur (+ i 1))))
                               (else (recur (+ i 1)))))))
(eratosthenes 100)
