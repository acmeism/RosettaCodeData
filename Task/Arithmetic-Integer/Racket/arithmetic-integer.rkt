#lang racket/base

(define (arithmetic x y)
  (for ([op (list + - * / quotient remainder modulo max min gcd lcm)])
    (printf "~s => ~s\n" `(,(object-name op) ,x ,y) (op x y))))

(arithmetic 8 12)
