#lang racket/base

(define (main)
  (let ([n 42])
    (printf "n = ~a, -n = ~a, two's complement = ~a\n"
            n (- n) (add1 (bitwise-not n)))))

(module+ main
  (main))
