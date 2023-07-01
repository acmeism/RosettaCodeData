#lang racket/base

(define (isbn13-check-digit-valid? s)
  (zero? (modulo (for/sum ((i (in-naturals))
                           (d (regexp-replace* #px"[^[:digit:]]" s "")))
                   (* (- (char->integer d) (char->integer #\0))
                      (if (even? i) 1 3)))
                 10)))

(module+ test
  (require rackunit)
  (check-true (isbn13-check-digit-valid? "978-1734314502"))
  (check-false (isbn13-check-digit-valid? "978-1734314509"))
  (check-true (isbn13-check-digit-valid? "978-1788399081"))
  (check-false (isbn13-check-digit-valid? "978-1788399083")))
