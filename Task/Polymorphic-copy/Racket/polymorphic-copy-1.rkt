#lang racket/base

(define (copy-prefab-struct str)
  (apply make-prefab-struct (vector->list (struct->vector str))))

(struct point (x y) #:prefab)
(struct point/color point (color) #:prefab)


(let* ([original (point 0 0)]
       [copied (copy-prefab-struct original)])
  (displayln copied)
  (displayln (eq? original copied)))

(let* ([original (point/color 0 0 'black)]
       [copied (copy-prefab-struct original)])
  (displayln copied)
  (displayln (eq? original copied)))
