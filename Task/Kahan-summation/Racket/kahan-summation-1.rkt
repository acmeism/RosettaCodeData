#lang racket

(define (sum/kahan . args)
  (define-values (sum c)
    (for/fold ([sum 0] [c 0]) ([num args])
      (define y (- num c))
      (define t (+ sum y))
      (values t (- (- t sum) y))))
  sum)

(displayln "Single presition flonum")
(+ 1000000.0f0 3.14159f0 2.71828f0)
(sum/kahan 1000000.0f0 3.14159f0 2.71828f0)

(displayln "Double presition flonum")
(+ 1000000.0 3.14159 2.71828)
(sum/kahan 1000000.0 3.14159 2.71828)
