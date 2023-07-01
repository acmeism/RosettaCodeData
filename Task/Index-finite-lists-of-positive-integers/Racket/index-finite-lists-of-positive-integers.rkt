#lang racket/base
(require (only-in racket/string string-join string-split))

(define (integer->octal-string i)
  (number->string i 8))

(define (octal-string->integer s)
  (string->number s 8))

(define (rank is)
  (string->number (string-join (map integer->octal-string is) "8")))

(define (unrank ranking)
  (map octal-string->integer (string-split (number->string ranking 10) "8")))

(module+ test
  (define loi '(1 2 3 10 100 987654321 135792468107264516704251 7))
  (define rnk (rank loi))
  (define urk (unrank rnk))
  (displayln loi)
  (displayln rnk)
  (displayln urk))
