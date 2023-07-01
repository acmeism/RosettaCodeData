#lang at-exp racket
(require data/order scribble/html)

;; Returns the area of a triangle iff the sides have gcd 1, and it is an
;; integer; #f otherwise
(define (heronian?-area a b c)
  (and (= 1 (gcd a b c))
       (let ([s (/ (+ a b c) 2)])  ; ** If s=\frac{a+b+c}{2}
         (and (integer? s)         ; (s must be an integer for the area to b an integer)
              (let-values ([[q r] (integer-sqrt/remainder ; (faster than sqrt)
                                   ; ** Then the area is \sqrt{s(s-a)(s-b)(s-c)}
                                   (* s (- s a) (- s b) (- s c)))])
                (and (zero? r) q)))))) ; (return only integer areas)

(define (generate-heronian-triangles max-side)
  (for*/list ([c (in-range 1 (add1 max-side))]
              [b (in-range 1 (add1 c))] ; b<=c
              [a (in-range (add1 (- c b)) (add1 b))] ; ensures a<=b and c<a+b
              [area (in-value (heronian?-area a b c))]
              #:when area)
    ;; datum-order can sort this for the tables (c is the max side length)
    (list area (+ a b c) c (list a b c))))

;; Order the triangles by first increasing area, then by increasing perimeter,
;; then by increasing maximum side lengths
(define (tri-sort triangles)
  (sort triangles (λ(t1 t2) (eq? '< (datum-order t1 t2)))))

(define (triangles->table triangles)
  (table
   (tr (map th '("#" sides perimeter area))) "\n"
   (for/list ([i (in-naturals 1)] [triangle (in-list triangles)])
     (match-define (list area perimeter max-side sides) triangle)
     (tr (td i) (td (add-between sides ",")) (td perimeter) (td area) "\n"))))

(module+ main
  (define ts (generate-heronian-triangles 200))
  (output-xml
   @div{@p{number of primitive triangles found with perimeter @entity{le} 200 = @(length ts)}
        @; Show the first ten ordered triangles in a table of sides, perimeter,
        @; and area.
        @(triangles->table (take (tri-sort ts) 10))
        @; Show a similar ordered table for those triangles with area = 210
        @(triangles->table (tri-sort (filter (λ(t) (eq? 210 (car t))) ts)))
        }))
