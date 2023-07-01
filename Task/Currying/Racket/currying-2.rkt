#lang racket

(define ((curried+ a) b)
  (+ a b))

((curried+ 3) 2)  ; => 5
