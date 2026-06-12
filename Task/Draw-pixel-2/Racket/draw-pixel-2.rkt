#lang racket/gui

(define WIDTH 640)
(define HEIGHT 480)
(define COLOR (make-color 255 255 0))
(define BACKGROUND-COLOR (make-color 0 0 0))

(define frame (new frame%
                   [label "Draw Pixel"]
                   [width WIDTH]
                   [height HEIGHT]))

(new canvas% [parent frame]
     [paint-callback
      (λ (canvas dc)
        (send dc set-background BACKGROUND-COLOR)
        (send dc clear)
        (send dc set-pen COLOR 1 'solid)
        (send dc draw-point (random WIDTH) (random HEIGHT)))])

(send frame show #t)
