#lang racket

(require math/number-theory)

(define (sum-of-digits n (σ 0))
  (if (zero? n) σ (let-values (((q r) (quotient/remainder n 10)))
                    (sum-of-digits q (+ σ r)))))

(define (additive-prime? n)
  (and (prime? n) (prime? (sum-of-digits n))))

(define additive-primes<500 (filter additive-prime? (range 1 500)))
(printf "There are ~a additive primes < 500~%" (length additive-primes<500))
(printf "They are: ~a~%" additive-primes<500)
