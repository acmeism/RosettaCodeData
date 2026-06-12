#lang racket
(require images/flomap)

(define fm
  (draw-flomap
   (λ (dc)
     (define (pixel x y color)
       (send dc set-pen color 1 'solid)
       (send dc draw-point (+ x .5) (+ y 0.5)))
     (send dc set-alpha 1)
     (pixel 0 0 "blue")
     (pixel 0 1 "red")
     (pixel 1 0 "red")
     (pixel 1 1 "green"))
   2 2))

(flomap->bitmap
 (build-flomap
  4 250 250
  (λ (k x y)
    (flomap-bilinear-ref
     fm k (+ 1/2 (/ x 250)) (+ 1/2 (/ y 250))))))
