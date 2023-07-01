#lang racket
(define (middle x)
  (cond
    [(negative? x) (middle (- x))]
    [(< x 100)     "error: number too small"]
    [else
     (define s (number->string x))
     (define l (string-length s))
     (cond [(even? l) "error: number has even length"]
           [else (define i (quotient l 2))
                 (substring s (- i 1) (+ i 2))])]))

(map middle (list 123 12345 1234567 987654321 10001 -10001 -123 -100 100 -12345))
(map middle (list 1 2 -1 -10 2002 -2002 0))
