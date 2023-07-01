#lang racket
(require "hidato-family-solver.rkt")

(define moore-neighbour-offsets
  '((+1 0) (-1 0) (0 +1) (0 -1) (+1 +1) (-1 -1) (-1 +1) (+1 -1)))

(define solve-hidato (solve-hidato-family moore-neighbour-offsets))

(displayln
 (puzzle->string
  (solve-hidato
   #(#( 0 33 35  0  0)
     #( 0  0 24 22  0)
     #( 0  0  0 21  0  0)
     #( 0 26  0 13 40 11)
     #(27  0  0  0  9  0  1)
     #( _  _  0  0 18  0  0)
     #( _  _  _  _  0  7  0  0)
     #( _  _  _  _  _  _  5  0)))))
