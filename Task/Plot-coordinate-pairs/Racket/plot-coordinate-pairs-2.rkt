#lang racket
(require plot)

(define x (build-list 10 values))
(define y (list 2.7 2.8 31.4 38.1 58.0 76.2 100.5 130.0 149.3 180.0))

(plot-new-window? #t)
(plot (lines (map vector x y)))
