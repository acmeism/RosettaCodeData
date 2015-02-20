#lang racket
(require plot/utils)

(define (circle-centers p1 p2 r)
  (when (zero? r) (err "zero radius."))
  (when (equal? p1 p2) (err "the points coinside."))
  ; the midle point
  (define m (v/ (v+ p1 p2) 2))
  ; the vector connecting given points
  (define d (v/ (v- p1 p2) 2))
  ; the distance between the center of the circle and the middle point
  (define ξ (- (sqr r) (vmag^2 d)))
  (when (negative? ξ) (err "given radius is less then the distance between points."))
  ; the unit vector orthogonal to the delta
  (define n (vnormalize (orth d)))
  ; the shift along the direction orthogonal to the delta
  (define x (v* n (sqrt ξ)))
  (values (v+ m x) (v- m x)))

;; error message
(define (err m) (error "Impossible to build a circle:" m))

;; returns a vector which is orthogonal to the geven one
(define orth (match-lambda [(vector x y) (vector y (- x))]))
