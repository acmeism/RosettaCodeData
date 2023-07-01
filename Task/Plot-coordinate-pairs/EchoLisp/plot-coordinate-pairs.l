(lib 'plot)

(define ys #(2.7 2.8 31.4 38.1 58.0 76.2 100.5 130.0 149.3 180.0) )
(define (f n) [ys n])

(plot-sequence f 9)
    → (("x:auto" 0 9) ("y:auto" 2 198))
(plot-grid 1 20)
(plot-text " Rosetta plot coordinate pairs" 0 10 "white")
