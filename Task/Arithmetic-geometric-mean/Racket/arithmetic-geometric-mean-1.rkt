#lang racket
(define (agm a g [ε 1e-15])
  (if (<= (- a g) ε)
      a
      (agm (/ (+ a g) 2) (sqrt (* a g)) ε)))

(agm 1 (/ 1 (sqrt 2)))
