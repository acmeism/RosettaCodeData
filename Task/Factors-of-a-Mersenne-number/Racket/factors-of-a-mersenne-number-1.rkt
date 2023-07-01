#lang racket

(define (number->digits n)
  (map (compose1 string->number string)
       (string->list (number->string n 2))))

(define (modpow exp base)
  (for/fold ([square 1])
    ([d (number->digits exp)])
    (modulo (* (if (= d 1) 2 1) square square) base)))

; Search through all integers from 1 on to find the first divisor.
; Returns #f if 2^p-1 is prime.
(define (mersenne-factor p)
  (for/first ([i (in-range 1 (floor (expt 2 (quotient p 2))) (* 2 p))]
              #:when (and (member (modulo i 8) '(1 7))
                          (= 1 (modpow p i))))
    i))

(mersenne-factor 929)
