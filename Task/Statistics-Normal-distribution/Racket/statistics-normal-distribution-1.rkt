#lang racket
(require math (planet williams/science/histogram-with-graphics))

(define data (sample (normal-dist 50 4) 100000))

(displayln (~a "Mean:\t"   (mean data)))
(displayln (~a "Stddev:\t" (stddev data)))
(displayln (~a "Max:\t"    (apply max data)))
(displayln (~a "Min:\t"    (apply min data)))

(define h (make-histogram-with-ranges-uniform 40 30 70))
(for ([x data]) (histogram-increment! h x))
(histogram-plot h "Normal distribution μ=50 σ=4")
