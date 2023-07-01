#lang racket
(require "Fibonacci-word.rkt")
(require graphics/value-turtles)

(define word-order 23) ; is a 3k+2 fractal, shaped like an n
(define height 420)
(define width 600)

(define the-word
  (parameterize ((f-word-max-length #f))
    (F-Word word-order)))

(for/fold ((T (turtles width height
                       0 height ; in BL corner
                       (/ pi -2)))) ; point north
  ((i (in-naturals))
   (j (in-string (f-word-str the-word))))
  (match* (i j)
    ((_ #\1) (draw 1 T))
    (((? even?) #\0) (turn -90 (draw 1 T)))
    ((_ #\0) (turn 90 (draw 1 T)))))
