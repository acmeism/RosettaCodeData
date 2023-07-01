#lang racket/base

(define-syntax-rule (all-between-0..1? x ...)
  (and (<= 0 x 1) ...))

(define (point-in-triangle?/barycentric x1 y1 x2 y2 x3 y3)
  (let* ((y2-y3 (- y2 y3))
         (x1-x3 (- x1 x3))
         (x3-x2 (- x3 x2))
         (y1-y3 (- y1 y3))
         (d (+ (* y2-y3 x1-x3) (* x3-x2 y1-y3))))
    (λ (x y)
      (define a (/ (+ (* x3-x2 (- y y3)) (* y2-y3 (- x x3))) d))
      (define b (/ (- (* x1-x3 (- y y3)) (* y1-y3 (- x x3))) d))
      (define c (- 1 a b))
      (all-between-0..1? a b c))))

(define (point-in-triangle?/parametric x1 y1 x2 y2 x3 y3)
  (let ((dp (+ (* x1 (- y2 y3)) (* y1 (- x3 x2)) (* x2 y3) (- (* y2 x3)))))
    (λ (x y)
      (define t1 (/ (+ (* x (- y3 y1)) (* y (- x1 x3)) (- (* x1 y3)) (* y1 x3)) dp))
      (define t2 (/ (+ (* x (- y2 y1)) (* y (- x1 x2)) (- (* x1 y2)) (* y1 x2)) (- dp)))
      (all-between-0..1? t1 t2 (+ t1 t2)))))

(define (point-in-triangle?/dot-product X1 Y1 X2 Y2 X3 Y3)
  (λ (x y)
    (define (check-side x1 y1 x2 y2)
      (>= (+ (* (- y2 y1) (- x x1)) (* (- x1 x2) (- y y1))) 0))
    (and
     (check-side X1 Y1 X2 Y2)
     (check-side X2 Y2 X3 Y3)
     (check-side X3 Y3 X1 Y1))))

(module+ main
  (require rackunit)

  (define (run-tests point-in-triangle?)
    (define pit?-1 (point-in-triangle? #e1.5 #e2.4 #e5.1 #e-3.1 #e-3.8 #e1.2))
    (check-true (pit?-1 0 0))
    (check-true (pit?-1 0 1))
    (check-false (pit?-1 3 1))
    (check-true ((point-in-triangle? 1/10 1/9 25/2 100/3  25   10/9) #e5.414285714285714 #e14.349206349206348))
    ; exactly speaking, point is _not_ in the triangle
    (check-false ((point-in-triangle? 1/10 1/9 25/2 100/3 -25/2 50/3) #e5.414285714285714 #e14.349206349206348)))

  (run-tests point-in-triangle?/barycentric)
  (run-tests point-in-triangle?/parametric)
  (run-tests point-in-triangle?/dot-product))
