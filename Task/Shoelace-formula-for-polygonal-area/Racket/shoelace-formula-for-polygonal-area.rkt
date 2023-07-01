#lang racket/base

(struct P (x y))

(define (area . Ps)
  (define (A P-a P-b)
    (+ (for/sum ((p_i Ps)
                 (p_i+1 (in-sequences (cdr Ps)
                                      (in-value (car Ps)))))
         (* (P-a p_i) (P-b p_i+1)))))
  (/ (abs (- (A P-x P-y) (A P-y P-x))) 2))

(module+ main
  (area (P 3 4) (P 5 11) (P 12 8) (P 9 5) (P 5 6)))
