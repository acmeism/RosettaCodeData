#lang racket

(define (next-half-row r)
  (define r1 (for/list ([x r] [y (cdr r)]) (+ x y)))
  `(,(* 2 (car r1)) ,@(for/list ([x r1] [y (cdr r1)]) (+ x y)) 1 0))

(let loop ([n 15] [r '(1 0)])
  (cons (- (car r) (cadr r))
        (if (zero? n) '() (loop (sub1 n) (next-half-row r)))))
;; -> '(1 1 2 5 14 42 132 429 1430 4862 16796 58786 208012 742900
;;      2674440 9694845)
