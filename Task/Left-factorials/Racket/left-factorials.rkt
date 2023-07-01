#lang racket
(define ! (let ((rv# (make-hash))) (λ (n) (hash-ref! rv# n (λ () (if (= n 0) 1 (* n (! (- n 1)))))))))

(define (!n n)
  ;; note that in-range n is from 0 to n-1 inclusive
  (for/sum ((k (in-range n))) (! k)))

(define (dnl. s) (for-each displayln s))
(dnl
  "Display the left factorials for:"
  "zero through ten (inclusive)"
  (pretty-format (for/list ((i (in-range 0 (add1 10)))) (!n i)))
  "20 through 110 (inclusive) by tens"
  (pretty-format (for/list ((i (in-range 20 (add1 110) 10))) (!n i)))
  "Display the length (in decimal digits) of the left factorials for:"
  "1,000, 2,000 through 10,000 (inclusive), by thousands."
  (pretty-format (for/list ((i (in-range 1000 10001 1000))) (add1 (order-of-magnitude (!n i))))))
