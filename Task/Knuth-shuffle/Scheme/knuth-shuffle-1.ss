#!r6rs
(import (rnrs base (6))
        (srfi :27 random-bits))

(define (semireverse li n)
  (define (continue front back n)
    (cond
      ((null? back) front)
      ((zero? n) (cons (car back) (append front (cdr back))))
      (else (continue (cons (car back) front) (cdr back) (- n 1)))))
  (continue '() li n))

(define (shuffle li)
  (if (null? li)
      ()
      (let
          ((li-prime (semireverse li (random-integer (length li)))))
        (cons (car li-prime) (shuffle (cdr li-prime))))))
