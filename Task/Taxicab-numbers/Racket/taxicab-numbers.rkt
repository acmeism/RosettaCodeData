#lang racket

(define (cube x) (* x x x))

;floor of cubic root
(define (cubic-root x)
  (let ([aprox (inexact->exact (round (expt x (/ 1 3))))])
    (if (> (cube aprox) x)
        (- aprox 1)
        aprox)))

(let loop ([p 1] [n 1])
  (let ()
    (define pairs
      (for*/list ([j (in-range 1 (add1 (cubic-root (quotient n 2))))]
                  [k (in-value (cubic-root (- n (cube j))))]
                  #:when (= n (+ (cube j) (cube k))))
        (cons j k)))
    (if (>= (length pairs) 2)
      (begin
        (printf "~a: ~a" p n)
        (for ([pair (in-list pairs)])
          (printf " = ~a^3 + ~a^3" (car pair) (cdr pair)))
          (newline)
        (when (< p 25)
          (loop (add1 p) (add1 n))))
      (loop p (add1 n)))))
