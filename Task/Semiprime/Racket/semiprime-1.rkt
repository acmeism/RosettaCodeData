#lang racket
(require math)

(define (pair-factorize n)
  "Return all two-number factorizations of a number"
  (let ([up-limit (integer-sqrt n)])
    (map (λ (x) (list x (/ n x)))
	 (filter (λ (x) (<= x up-limit)) (divisors n)))))

(define (semiprime n)
  "Determine if a number is semiprime i.e. a product of two primes.
Check if any pair of complete factors consists of primes."
  (for/or ((pair (pair-factorize n)))
    (for/and ((el pair))
      (prime? el))))
