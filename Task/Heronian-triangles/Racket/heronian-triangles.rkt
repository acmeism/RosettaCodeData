#lang racket
(require xml/xml data/order)

;; Returns the area of triangle sides a, b, c
(define (A a b c)
  (define s (/ (+ a b c) 2)) ; where s=\frac{a+b+c}{2}.
  (sqrt (* s (- s a) (- s b) (- s c)))) ; A = \sqrt{s(s-a)(s-b)(s-c)}

;; Returns same as A iff a, b, c and A are integers; #f otherwise
(define (heronian?-area a b c)
  (and (integer? a) (integer? b) (integer? c)
       (let ((h (A a b c))) (and (integer? h) h))))

;; Returns same as heronian?-area, with the additional condition that (gcd a b c) = 1
(define (primitive-heronian?-area a b c)
  (and (= 1 (gcd a b c))
       (heronian?-area a b c)))

(define (generate-heronian-triangles max-side)
  (for*/list
      ((a (in-range 1 (add1 max-side)))
       (b (in-range 1 (add1 a)))
       (c (in-range 1 (add1 b)))
       #:when (< a (+ b c))
       (h (in-value (primitive-heronian?-area a b c)))
       #:when h)
    (define rv (vector h (+ a b c) (sort (list a b c) >))) ; datum-order can sort this for the tables
    rv))

;; Order the triangles by first increasing area, then by increasing perimeter,
;; then by increasing maximum side lengths
(define (tri<? t1 t2)
  (eq? '< (datum-order t1 t2)))

(define triangle->tds (match-lambda [`#(,h ,p ,s) `((td ,(~a s)) (td ,(~a p)) (td ,(~a h)))]))

(define (triangles->table ts)
  `(table
    (tr (th "#") (th "sides") (th "perimiter") (th "area")) "\n"
    ,@(for/list ((i (in-naturals 1)) (t ts)) `(tr (td ,(~a i)) ,@(triangle->tds t) "\n"))))

(define (sorted-triangles-table triangles)
  (triangles->table (sort triangles tri<?)))

(module+ main
  (define ts (generate-heronian-triangles 200))
  (define div-out
    `(div
      (p "number of primitive triangles found with perimeter "le" 200 = " ,(~a (length ts))) "\n"
      ;; Show the first ten ordered triangles in a table of sides, perimeter, and area.
      ,(sorted-triangles-table (take (sort ts tri<?) 10)) "\n"
      ;; Show a similar ordered table for those triangles with area = 210
      ,(sorted-triangles-table (sort (filter (match-lambda [(vector 210 _ _) #t] [_ #f]) ts) tri<?))))

  (displayln (xexpr->string div-out)))
