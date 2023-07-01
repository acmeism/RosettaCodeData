#lang racket
(define (dist z0 z1) (magnitude (- z1 z0)))
(define (dist* zs)  (apply dist zs))

(define (closest-pair zs)
  (if (< (length zs) 2)
      -inf.0
      (first
       (sort (for/list ([z0 zs])
               (list z0 (argmin (λ(z) (if (= z z0) +inf.0 (dist z z0))) zs)))
             < #:key dist*))))

(define result (closest-pair '(0+1i 1+2i 3+4i)))
(displayln (~a "Closest points: " result))
(displayln (~a "Distance: " (dist* result)))
