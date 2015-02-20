#lang racket
(require math/number-theory rnrs/arithmetic/bitwise-6)

(define pernicious? (compose prime? bitwise-bit-count))

(define (dnl . strs)
  (for-each displayln strs))

(define (show-sequence seq)
  (string-join (for/list ((v (in-values*-sequence seq))) (~a ((if (list? v) car values) v))) ", "))

(dnl
 "Task requirements:"
 "display the first 25 pernicious numbers."
 (show-sequence (in-parallel (sequence-filter pernicious? (in-naturals 1)) (in-range 25)))
 "display all pernicious numbers between 888,888,877 and 888,888,888 (inclusive)."
 (show-sequence (sequence-filter pernicious? (in-range 888888877 (add1 888888888)))))

(module+ test
  (require rackunit)
  (check-true (pernicious? 22)))
