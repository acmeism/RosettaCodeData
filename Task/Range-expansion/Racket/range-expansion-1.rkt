#lang racket

(define (range-expand s)
  (append*
   (for/list ([r (regexp-split "," s)])
     (match (regexp-match* "(-?[0-9]+)-(-?[0-9]+)" r
                           #:match-select cdr)
       [(list (list f t))
        (range (string->number f) (+ (string->number t) 1))]
       [(list)
        (list (string->number r))]))))

(range-expand "-6,-3--1,3-5,7-11,14,15,17-20")
