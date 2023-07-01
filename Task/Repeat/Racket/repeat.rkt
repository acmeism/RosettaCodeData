#lang racket/base
(define (repeat f n) ; the for loop is idiomatic of (although not exclusive to) racket
  (for ((_ n)) (f)))

(define (repeat2 f n) ; This is a bit more "functional programmingy"
  (when (positive? n) (f) (repeat2 f (sub1 n))))

(display "...")
(repeat (λ () (display " and over")) 5)
(display "...")
(repeat2 (λ () (display " & over")) 5)
(newline)
