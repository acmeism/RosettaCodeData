#lang racket/gui
(require math/matrix math/array)

(define (Rx θ)
  (matrix [[1.0    0.0        0.0]
           [0.0 (cos θ) (- (sin θ))]
           [0.0 (sin θ)    (cos θ)]]))

(define (Ry θ)
  (matrix [[   (cos θ)  0.0 (sin θ)]
           [      0.0   1.0    0.0 ]
           [(- (sin θ)) 0.0 (cos θ)]]))

(define (Rz θ)
  (matrix [[(cos θ) (- (sin θ)) 0.0]
           [(sin θ)    (cos θ)  0.0]
           [   0.0        0.0   1.0]]))

(define base-matrix
  (matrix* (identity-matrix 3 100.0)
           (Rx (- (/ pi 2) (atan (sqrt 2))))
           (Rz (/ pi 4.0))))

(define (current-matrix)
  (matrix* (Ry (/ (current-inexact-milliseconds) 1000.))
           base-matrix))

(define corners
  (for*/list ([x '(-1.0 1.0)]
              [y '(-1.0 1.0)]
              [z '(-1.0 1.0)])
    (matrix [[x] [y] [z]])))

(define lines
  '((0 1) (0 2) (0 4) (1 3) (1 5)
    (2 3) (2 6) (3 7) (4 5) (4 6)
    (5 7) (6 7)))

(define ox 200.)
(define oy 200.)

(define (draw-line dc a b)
  (send dc draw-line
        (+ ox (array-ref a #(0 0)))
        (+ oy (array-ref a #(1 0)))
        (+ ox (array-ref b #(0 0)))
        (+ oy (array-ref b #(1 0)))))

(define (draw-cube c dc)
  (define-values (w h) (send dc get-size))
  (set! ox (/ w 2))
  (set! oy (/ h 2))
  (define cs (for/vector ([c (in-list corners)])
               (matrix* (current-matrix) c)))
  (for ([l (in-list lines)])
    (match-define (list i j) l)
    (draw-line dc (vector-ref cs i) (vector-ref cs j))))

(define f (new frame%  [label "cube"]))
(define c (new canvas% [parent f] [min-width 400] [min-height 400] [paint-callback draw-cube]))
(send f show #t)

(send* (send c get-dc)
  (set-pen "black" 1 'solid)
  (set-smoothing 'smoothed))

(define (refresh)
  (send c refresh))

(define t (new timer% [notify-callback refresh] [interval 35] [just-once? #f]))
