#lang racket

(module sutherland-hodgman racket
  (provide clip-to)
  (provide make-edges)
  (provide (struct-out point))

  (struct point (x y) #:transparent)
  (struct edge (p1 p2) #:transparent)
  (struct polygon (points edges) #:transparent)

  (define (make-edges points)
    (let ([points-shifted
	   (match points
	     [(list a b ...) (append b (list a))])])
      (map edge points points-shifted)))

  (define (is-point-left? pt ln)
    (match-let ([(point x y) pt]
                [(edge (point px py) (point qx qy)) ln])
               (>= (* (- qx px) (- y py))
                   (* (- qy py) (- x px)))))

  ;; Return the intersection of two lines
  (define (isect-lines l1 l2)
    (match-let ([(edge (point x1 y1) (point x2 y2)) l1]
                [(edge (point x3 y3) (point x4 y4)) l2])
               (let* ([r (- (* x1 y2) (* y1 x2))] [s (- (* x3 y4) (* y3 x4))]
                      [t (- x1 x2)] [u (- y3 y4)] [v (- y1 y2)] [w (- x3 x4)]
                      [d (- (* t u) (* v w))])
                 (point (/ (- (* r w) (* t s)) d)
                        (/ (- (* r u) (* v s)) d)))))

  ;; Intersect the line segment (p0,p1) with the clipping line's left halfspace,
  ;; returning the point closest to p1.  In the special case where p0 lies outside
  ;; the halfspace and p1 lies inside we return both the intersection point and p1.
  ;; This ensures we will have the necessary segment along the clipping line.

  (define (intersect segment clip-line)
    (define (isect) (isect-lines segment clip-line))

    (match-let ([(edge p0 p1) segment])
               (match/values (values (is-point-left? p0 clip-line) (is-point-left? p1 clip-line))
                             [(#f #f) '()]
                             [(#f #t) (list (isect) p1)]
                             [(#t #f) (list (isect))]
                             [(#t #t) (list p1)])))

  ;; Intersect the polygon with the clipping line's left halfspace
  (define (isect-polygon poly-edges clip-line)
    (for/fold ([p '()]) ([e  poly-edges])
      (append p (intersect e clip-line))))

  ;; Intersect a subject polygon with a clipping polygon.  The latter is assumed to be convex.
  (define (clip-to sp-pts cp-edges)
    (for/fold ([out-poly sp-pts]) ([clip-line cp-edges])
      (isect-polygon (make-edges out-poly) clip-line))))
