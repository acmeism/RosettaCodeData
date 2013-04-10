#lang racket
;; Natural -> Natural
;; Calculate fibonacci
(define (fibb n)
  (define (fibb-helper n fibb_n-1 fibb_n-2)
    (if (= 1 n)
        fibb_n-1
        (fibb-helper (sub1 n) (+ fibb_n-1 fibb_n-2) fibb_n-1)))
  (unless (exact-nonnegative-integer? n)
    (raise-argument-error 'fibb "natural" n))
  (if (zero? n) 0 (fibb-helper n 1 0)))

;; Unit tests, works in v5.3 and newer
(module+ test
  (require rackunit)
  (check-exn exn:fail? (lambda () (fibb -2)))
  (check-equal?
   (for/list ([i (in-range 21)]) (fibb i))
   '(0 1 1 2 3 5 8 13 21 34 55 89 144 233
       377 610 987 1597 2584 4181 6765)))
