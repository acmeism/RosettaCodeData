#lang racket

(define limit 100)

(define (divisor-count n)
  (length (filter (λ (x) (zero? (remainder n x))) (range 1 (add1 n)))))

(printf "Count of divisors of the integers from 1 to ~a are~n" limit)
(for ([n (in-range 1 (add1 limit))])
  (printf (~a (divisor-count n) #:width 5 #:align 'right))
  (when (zero? (remainder n 10))
    (newline)))
