#lang racket/base
(require rackunit
         ;; usually, included in "racket", but we're using racket/base so we
         ;; show where this comes from
         (only-in racket/list cartesian-product))
;; these tests will pass silently
(check-equal? (cartesian-product '(1 2) '(3 4))
             '((1 3) (1 4) (2 3) (2 4)))
(check-equal? (cartesian-product '(3 4) '(1 2))
             '((3 1) (3 2) (4 1) (4 2)))
(check-equal? (cartesian-product '(1 2) '()) '())
(check-equal? (cartesian-product '() '(1 2)) '())

;; these will print
(cartesian-product '(1776 1789) '(7 12) '(4 14 23) '(0 1))
(cartesian-product '(1 2 3) '(30) '(500 100))
(cartesian-product '(1 2 3) '() '(500 100))
