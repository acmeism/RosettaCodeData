#lang racket

(require metapict)

; rot: rotate d degrees around point p, where c is a point or curve
(def (rot d p c)
  (rotated-aboutd d p c))

(define (koch a b n)
  (match n
    [0 (draw (curve a -- b))]
    [_ (def 1/3ab (med 1/3 a b))
       (def 2/3ab (med 2/3 a b))
       (draw (koch a 1/3ab                      (- n 1))
             (koch 1/3ab (rot 60 1/3ab 2/3ab)   (- n 1))
             (koch (rot 60 1/3ab 2/3ab) 2/3ab   (- n 1))
             (koch 2/3ab b                      (- n 1)))]))

(define (snow n)
  (def a (pt 0 0))
  (def b (pt 1 0))
  (def c (rot 60 a b))
  (draw (koch b a n)
        (koch c b n)
        (koch a c n)))

(scale 4 (snow 2))
