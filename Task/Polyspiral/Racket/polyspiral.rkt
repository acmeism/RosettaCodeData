#lang racket

(require 2htdp/universe pict racket/draw)

(define ((polyspiral width height segment-length-increment n-segments) tick/s/28)
  (define turn-angle (degrees->radians (/ tick/s/28 8)))
  (pict->bitmap
   (dc (λ (dc dx dy)
         (define old-brush (send dc get-brush))
         (define old-pen (send dc get-pen))
         (define path (new dc-path%))
         (define x (/ width #i2))
         (define y (/ height #i2))
         (send path move-to x y)
         (for/fold ((x x) (y y) (l segment-length-increment) (a #i0))
                   ((seg n-segments))
           (define x′ (+ x (* l (cos a))))
           (define y′ (+ y (* l (sin a))))
           (send path line-to x y)
           (values x′ y′ (+ l segment-length-increment) (+ a turn-angle)))
         (send dc draw-path path dx dy)
         (send* dc (set-brush old-brush) (set-pen old-pen)))
       width height)))

(animate (polyspiral 400 400 2 1000))
