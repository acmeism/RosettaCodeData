#lang racket

(define limit 100)

(define (divisor-count n)
  (length (filter (λ (x) (zero? (remainder n x))) (range 1 (+ 1 n)))))

(define (display-tau-numbers (n 1) (count 1))
  (when (<= count limit)
    (if (zero? (remainder n (divisor-count n)))
       (begin
         (printf (~a n #:width 5 #:align 'right))
         (when (zero? (remainder count 10))
           (newline))
         (display-tau-numbers (add1 n) (add1 count)))
       (display-tau-numbers (add1 n) count))))

(printf "The first ~a Τau numbers are~n" limit)
(display-tau-numbers)
