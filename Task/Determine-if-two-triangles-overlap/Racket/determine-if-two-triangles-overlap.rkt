#lang racket

;; A triangle is a list of three pairs of points: '((x . y) (x . y) (x . y))
(define (to-tri x1 y1 x2 y2 x3 y3) `((,x1 . ,y1) (,x2 . ,y2) (,x3 . ,y3)))

(define det-2D
  (match-lambda
    [`((,x1 . ,y1) (,x2 . ,y2) (,x3 . ,y3)) (+ (* x1 (- y2 y3)) (* x2 (- y3 y1)) (* x3 (- y1 y2)))]))

(define (assert-triangle-winding triangle allow-reversed?)
  (cond
    [(>= (det-2D triangle) 0) triangle]
    [allow-reversed? (match triangle [(list p1 p2 p3) (list p1 p3 p2)])]
    [else (error 'assert-triangle-winding "triangle is wound in wrong direction")]))

(define (tri-tri-2d? triangle1 triangle2
                     #:ϵ (ϵ 0)
                     #:allow-reversed? (allow-reversed? #f)
                     #:on-boundary? (on-boundary? #t))
  (define check-edge
    (if on-boundary? ; Points on the boundary are considered as colliding
        (λ (triangle) (< (det-2D triangle) ϵ))
        (λ (triangle) (<= (det-2D triangle) ϵ))))

  (define (inr t1 t2)
    (for*/and ((i (in-range 3)))
      ;; Check all points of trangle 2 lay on the external side
      ;; of the edge E. If they do, the triangles do not collide.
      (define t1.i (list-ref t1 i))
      (define t1.j (list-ref t1 (modulo (add1 i) 3)))
      (not (for/and ((k (in-range 3))) (check-edge (list (list-ref t2 k) t1.i t1.j))))))

  (let (;; Trangles must be expressed anti-clockwise
        (tri1 (assert-triangle-winding triangle1 allow-reversed?))
        (tri2 (assert-triangle-winding triangle2 allow-reversed?)))
    (and (inr tri1 tri2) (inr tri2 tri1))))

;; ---------------------------------------------------------------------------------------------------
(module+ test
  (require rackunit)

  (define triangleses ; pairs of triangles
    (for/list ((a.b (in-list '(((0 0  5 0  0   5) (  0 0   5    0   0 6))
                               ((0 0  0 5  5   0) (  0 0   0    5   5 0))
                               ((0 0  5 0  0   5) (-10 0  -5    0  -1 6))
                               ((0 0  5 0  2.5 5) (  0 4   2.5 -1   5 4))
                               ((0 0  1 1  0   2) (  2 1   3    0   3 2))
                               ((0 0  1 1  0   2) (  2 1   3   -2   3 4))))))
      (map (curry apply to-tri) a.b)))

  (check-equal?
   (for/list ((t1.t2 (in-list triangleses)))
     (define t1 (first t1.t2))
     (define t2 (second t1.t2))
     (define-values (r reversed?)
       (with-handlers ([exn:fail? (λ (_) (values (tri-tri-2d? t1 t2 #:allow-reversed? #t) #t))])
         (values (tri-tri-2d? t1 t2) #f)))
     (cons r reversed?))
   '((#t . #f) (#t . #t) (#f . #f) (#t . #f) (#f . #f) (#f . #f)))

  (let ((c1 (to-tri 0 0  1 0  0 1)) (c2 (to-tri 1 0  2 0  1 1)))
    (check-true (tri-tri-2d? c1 c2 #:on-boundary? #t))
    (check-false (tri-tri-2d? c1 c2 #:on-boundary? #f))))
