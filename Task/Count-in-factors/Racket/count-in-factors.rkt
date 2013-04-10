#lang racket
(require math)

(define (~ f)
  (match f
    [(list p 1) (~a p)]
    [(list p n) (~a p "^" n)]))

(define (factors fs)
  (add-between (map ~ fs) " * "))

(for ([x (in-range 2 20)])
  (display (~a x " = "))
  (map display (factors (factorize x)))
  (newline))
