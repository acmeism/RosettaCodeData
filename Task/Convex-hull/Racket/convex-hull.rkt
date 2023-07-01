#lang typed/racket
(define-type Point (Pair Real Real))
(define-type Points (Listof Point))

(: ⊗ (Point Point Point -> Real))
(define/match (⊗ o a b)
  [((cons o.x o.y) (cons a.x a.y) (cons b.x b.y))
   (- (* (- a.x o.x) (- b.y o.y)) (* (- a.y o.y) (- b.x o.x)))])

(: Point<? (Point Point -> Boolean))
(define (Point<? a b)
  (cond [(< (car a) (car b)) #t] [(> (car a) (car b)) #f] [else (< (cdr a) (cdr b))]))

;; Input: a list P of points in the plane.
(define (convex-hull [P:unsorted : Points])
  ;; Sort the points of P by x-coordinate (in case of a tie, sort by y-coordinate).
  (define P (sort P:unsorted Point<?))
  ;; for i = 1, 2, ..., n:
  ;;     while L contains at least two points and the sequence of last two points
  ;;             of L and the point P[i] does not make a counter-clockwise turn:
  ;;        remove the last point from L
  ;;     append P[i] to L
  ;; TB: U is identical with (reverse P)
  (define (upper/lower-hull [P : Points])
    (reverse
     (for/fold ((rev : Points null))
       ((P.i (in-list P)))
       (let u/l : Points ((rev rev))
         (match rev
           [(list p-2 p-1 ps ...) #:when (not (positive? (⊗ p-2 P.i p-1))) (u/l (list* p-1 ps))]
           [(list ps ...) (cons P.i ps)])))))

  ;; Initialize U and L as empty lists.
  ;; The lists will hold the vertices of upper and lower hulls respectively.
  (let ((U (upper/lower-hull (reverse P)))
        (L (upper/lower-hull P)))
    ;; Remove the last point of each list (it's the same as the first point of the other list).
    ;; Concatenate L and U to obtain the convex hull of P.
    (append (drop-right L 1) (drop-right U 1)))) ; Points in the result will be listed in CCW order.)

(module+ test
  (require typed/rackunit)
  (check-equal?
   (convex-hull
    (list '(16 . 3) '(12 . 17) '(0 . 6) '(-4 . -6) '(16 . 6) '(16 . -7) '(16 . -3) '(17 . -4)
          '(5 . 19) '(19 . -8) '(3 . 16) '(12 . 13) '(3 . -4) '(17 . 5) '(-3 . 15) '(-3 . -9)
          '(0 . 11) '(-9 . -3) '(-4 . -2) '(12 . 10)))
   (list '(-9 . -3) '(-3 . -9) '(19 . -8) '(17 . 5) '(12 . 17) '(5 . 19) '(-3 . 15))))
