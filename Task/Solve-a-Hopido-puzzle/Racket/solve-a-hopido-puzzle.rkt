#lang racket
(require "hidato-family-solver.rkt")

(define hoppy-moore-neighbour-offsets
  '((+3 0) (-3 0) (0 +3) (0 -3) (+2 +2) (-2 -2) (-2 +2) (+2 -2)))

(define solve-hopido (solve-hidato-family hoppy-moore-neighbour-offsets))

(displayln
 (puzzle->string
  (solve-hopido
   #(#(_ 0 0 _ 0 0 _)
     #(0 0 0 0 0 0 0)
     #(0 0 0 0 0 0 0)
     #(_ 0 0 0 0 0 _)
     #(_ _ 0 0 0 _ _)
     #(_ _ _ 0 _ _ _)))))
