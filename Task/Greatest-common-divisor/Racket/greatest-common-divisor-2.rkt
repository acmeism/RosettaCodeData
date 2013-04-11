#lang racket

;; given two nonnegative integers, produces their greatest
;; common divisor using Euclid's algorithm
(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (modulo a b))))

;; some test cases!
(module+ test
  (require rackunit)
  (check-equal? (gcd (* 2 3 3 7 7)
                     (* 3 3 7 11))
                (* 3 3 7))
  (check-equal? (gcd 0 14) 14)
  (check-equal? (gcd 13 0) 13))
