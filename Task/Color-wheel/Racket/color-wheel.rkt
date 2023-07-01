#lang racket

(require racket/draw
         colors)

(define DIM 500)
(define target (make-bitmap DIM DIM))
(define dc (new bitmap-dc% [bitmap target]))
(define radius 200)
(define center (/ DIM 2))

(define (atan2 y x) (if (= 0 y x) 0 (atan y x)))

(for* ([x (in-range DIM)]
       [y (in-range DIM)]
       [rx (in-value (- x center))]
       [ry (in-value (- y center))]
       [s (in-value (/ (sqrt (+ (sqr rx) (sqr ry))) radius))]
       #:when (<= s 1))
  (define h (* 0.5 (+ 1 (/ (atan2 ry rx) pi))))
  (send dc set-pen (hsv->color (hsv (if (= 1 h) 0 h) s 1)) 1 'solid)
  (send dc draw-point x y))

target
