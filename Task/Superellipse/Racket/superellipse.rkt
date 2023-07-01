#lang racket
(require plot)
#;(plot-new-window? #t)

(define ((superellipse a b n) x y)
  (+ (expt (abs (/ x a)) n)
     (expt (abs (/ y b)) n)))

(plot (isoline (superellipse 200 200 2.5) 1
               -220 220 -220 220))
