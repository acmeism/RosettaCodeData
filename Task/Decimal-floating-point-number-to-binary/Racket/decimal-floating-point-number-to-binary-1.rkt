#lang racket

(define (string->number/binary x)
  (string->number x 2))

(string->number/binary "10.0101")
(newline)
(string->number/binary "0.01")
#b0.01
(string->number "0.01" 2)
(newline)
