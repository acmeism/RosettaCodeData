#lang racket

(define (lex-sort n) (sort (if (< 0 n) (range 1 (add1 n)) (range n 2))
                           string<? #:key number->string))

(define (show n) (printf "~a: ~a\n" n (lex-sort n)))

(show 0)
(show 1)
(show 5)
(show 13)
(show 21)
(show -22)
