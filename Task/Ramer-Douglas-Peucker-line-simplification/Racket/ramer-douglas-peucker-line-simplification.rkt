#lang racket
(require math/flonum)
;; points are lists of x y (maybe extensible to z)
;; x+y gets both parts as values
(define (x+y p) (values (first p) (second p)))

;; https://en.wikipedia.org/wiki/Distance_from_a_point_to_a_line
(define (⊥-distance P1 P2)
  (let*-values
      ([(x1 y1) (x+y P1)]
       [(x2 y2) (x+y P2)]
       [(dx dy) (values (- x2 x1) (- y2 y1))]
       [(h) (sqrt (+ (sqr dy) (sqr dx)))])
    (λ (P0)
      (let-values (((x0 y0) (x+y P0)))
        (/ (abs (+ (* dy x0) (* -1 dx y0) (* x2 y1) (* -1 y2 x1))) h)))))

(define (douglas-peucker points-in ϵ)
  (let recur ((ps points-in))
    ;; curried distance function which will be applicable to all points
    (let*-values
        ([(p0) (first ps)]
         [(pz) (last ps)]
         [(p-d) (⊥-distance p0 pz)]
         ;; Find the point with the maximum distance
         [(dmax index)
          (for/fold ((dmax 0) (index 0))
                    ((i (in-range 1 (sub1 (length ps))))) ; skips the first, stops before the last
            (define d (p-d (list-ref ps i)))
            (if (> d dmax) (values d i) (values dmax index)))])
      ;; If max distance is greater than epsilon, recursively simplify
      (if (> dmax ϵ)
          ;; recursive call
          (let-values ([(l r) (split-at ps index)])
            (append (drop-right (recur l) 1) (recur r)))
          (list p0 pz))))) ;; else we can return this simplification

(module+ main
  (douglas-peucker
   '((0 0) (1 0.1) (2 -0.1) (3 5) (4 6) (5 7) (6 8.1) (7 9) (8 9) (9 9))
   1.0))

(module+ test
  (require rackunit)
  (check-= ((⊥-distance '(0 0) '(0 1)) '(1 0)) 1 epsilon.0))
