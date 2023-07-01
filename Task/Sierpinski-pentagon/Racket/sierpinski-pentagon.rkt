#lang racket/base
(require racket/draw pict racket/math racket/class)

;; exterior angle
(define 72-degrees (degrees->radians 72))
;; After scaling we'll have 2 sides plus a gap occupying the length
;; of a side before scaling. The gap is the base of an isosceles triangle
;; with a base angle of 72 degrees.
(define scale-factor (/ (+ 2 (* (cos 72-degrees) 2))))
;; Starting at the top of the highest pentagon, calculate
;; the top vertices of the other pentagons by taking the
;; length of the scaled side plus the length of the gap.
(define dist-factor (+ 1 (* (cos 72-degrees) 2)))

;; don't use scale, since it scales brushes too (making lines all tiny)
(define (draw-pentagon x y side depth dc)
  (let recur ((x x) (y y) (side side) (depth depth))
    (cond
      [(zero? depth)
       (define p (new dc-path%))
       (send p move-to x y)
       (for/fold ((x x) (y y) (α (* 3 72-degrees))) ((i 5))
         (send p line-to x y)
         (values (+ x (* side (cos α)))
                 (- y (* side (sin α)))
                 (+ α 72-degrees)))
       (send p close)
       (send dc draw-path p)]
      [else
       (define side/ (* side scale-factor))
       (define dist (* side/ dist-factor))
       ;; The top positions form a virtual pentagon of their own,
       ;; so simply move from one to the other by changing direction.
       (for/fold ((x x) (y y) (α (* 3 72-degrees))) ((i 5))
         (recur x y side/ (sub1 depth))
         (values (+ x (* dist (cos α)))
                 (- y (* dist (sin α)))
                 (+ α 72-degrees)))])))

(define (dc-draw-pentagon depth w h #:margin (margin 4))
  (dc (lambda (dc dx dy)
        (define old-brush (send dc get-brush))
        (send dc set-brush (make-brush #:style 'transparent))
        (draw-pentagon (/ w 2)
                       (* 3 margin)
                       (* (- (/ w 2) (* 2 margin))
                          (sin (/ pi 5)) 2)
                       depth
                       dc)
        (send dc set-brush old-brush))
      w h))

(dc-draw-pentagon 1 120 120)
(dc-draw-pentagon 2 120 120)
(dc-draw-pentagon 3 120 120)
(dc-draw-pentagon 4 120 120)
(dc-draw-pentagon 5 640 640)
