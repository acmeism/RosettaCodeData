#lang racket/base
(define (det a b c d) (- (* a d) (* b c))) ; determinant

(define (line-intersect ax ay bx by cx cy dx dy) ; --> (values x y)
  (let* ((det.ab (det ax ay bx by))
         (det.cd (det cx cy dx dy))
         (abΔx (- ax bx))
         (cdΔx (- cx dx))
         (abΔy (- ay by))
         (cdΔy (- cy dy))
         (xnom (det det.ab abΔx det.cd cdΔx))
         (ynom (det det.ab abΔy det.cd cdΔy))
         (denom (det abΔx abΔy cdΔx cdΔy)))
    (when (zero? denom)
      (error 'line-intersect "parallel lines"))
    (values (/ xnom denom) (/ ynom denom))))

(module+ test (line-intersect 4 0 6 10
                              0 3 10 7))
