#! /usr/local/bin/newlisp

(define (ackermann m n)
  (cond ((zero? m) (inc n))
        ((zero? n) (ackermann (dec m) 1))
        (true (ackermann (- m 1) (ackermann m (dec n))))))
