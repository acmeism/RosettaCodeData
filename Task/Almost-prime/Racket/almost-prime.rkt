#lang racket
(require (only-in math/number-theory factorize))

(define ((k-almost-prime? k) n)
  (= k (for/sum ((f (factorize n))) (cadr f))))

(define KAP-table-values
  (for/list ((k (in-range 1 (add1 5))))
    (define kap? (k-almost-prime? k))
    (for/list ((j (in-range 10)) (i (sequence-filter kap? (in-naturals 1))))
      i)))

(define (format-table t)
  (define longest-number-length
    (add1 (order-of-magnitude (argmax order-of-magnitude (cons (length t) (apply append t))))))
  (define (fmt-val v) (~a v #:width longest-number-length #:align 'right))
  (string-join
   (for/list ((r t) (k (in-naturals 1)))
     (string-append
      (format "║ k = ~a║ " (fmt-val k))
      (string-join (for/list ((c r)) (fmt-val c)) "| ")
      "║"))
   "\n"))

(displayln (format-table KAP-table-values))
