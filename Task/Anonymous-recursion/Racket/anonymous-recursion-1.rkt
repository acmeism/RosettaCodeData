#lang racket

;; Natural -> Natural
;; Calculate factorial
(define (fact n)
  (define (fact-helper n acc)
    (if (= n 0)
        acc
        (fact-helper (sub1 n) (* n acc))))
  (unless (exact-nonnegative-integer? n)
    (raise-argument-error 'fact "natural" n))
  (fact-helper n 1))

;; Unit tests, works in v5.3 and newer
(module+ test
  (require rackunit)
  (check-equal? (fact 0) 1)
  (check-equal? (fact 5) 120))
