#lang racket
(require math)
(define (proper-divisors n) (drop-right (divisors n) 1))
(for ([n (in-range 1 (add1 10))])
  (printf "proper divisors of: ~a\t~a\n" n (proper-divisors n)))
(define most-under-20000
  (for/fold ([best '(1)]) ([n (in-range 2 (add1 20000))])
    (define divs (proper-divisors n))
    (if (< (length (cdr best)) (length divs)) (cons n divs) best)))
(printf "~a has ~a proper divisors\n"
        (car most-under-20000) (length (cdr most-under-20000)))
