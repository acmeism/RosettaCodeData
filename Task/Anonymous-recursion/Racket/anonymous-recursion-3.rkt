#lang racket
;; We use Z combinator (applicative order fixed-point operator)
(define Z
  (λ (f)
    ((λ (x) (f (λ (g) ((x x) g))))
     (λ (x) (f (λ (g) ((x x) g)))))))

(define fibonacci
  (Z (λ (fibo)
       (λ (n)
         (if (<= n 2)
             1
             (+ (fibo (- n 1))
                (fibo (- n 2))))))))
