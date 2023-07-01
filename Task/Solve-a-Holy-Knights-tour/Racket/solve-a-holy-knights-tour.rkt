#lang racket
(require "hidato-family-solver.rkt")

(define knights-neighbour-offsets
  '((+1 +2) (-1 +2) (+1 -2) (-1 -2) (+2 +1) (-2 +1) (+2 -1) (-2 -1)))

(define solve-a-knights-tour (solve-hidato-family knights-neighbour-offsets))

(displayln
 (puzzle->string
  (solve-a-knights-tour
   #(#(_ 0 0 0 _ _ _ _)
     #(_ 0 _ 0 0 _ _ _)
     #(_ 0 0 0 0 0 0 0)
     #(0 0 0 _ _ 0 _ 0)
     #(0 _ 0 _ _ 0 0 0)
     #(1 0 0 0 0 0 0 _)
     #(_ _ 0 0 _ 0 _ _)
     #(_ _ _ 0 0 0 _ _)))))

(newline)

(displayln
 (puzzle->string
  (solve-a-knights-tour
   #(#(- - - - - 1 - 0 - - - - -)
     #(- - - - - 0 - 0 - - - - -)
     #(- - - - 0 0 0 0 0 - - - -)
     #(- - - - - 0 0 0 - - - - -)
     #(- - 0 - - 0 - 0 - - 0 - -)
     #(0 0 0 0 0 - - - 0 0 0 0 0)
     #(- - 0 0 - - - - - 0 0 - -)
     #(0 0 0 0 0 - - - 0 0 0 0 0)
     #(- - 0 - - 0 - 0 - - 0 - -)
     #(- - - - - 0 0 0 - - - - -)
     #(- - - - 0 0 0 0 0 - - - -)
     #(- - - - - 0 - 0 - - - - -)
     #(- - - - - 0 - 0 - - - - -)))))
