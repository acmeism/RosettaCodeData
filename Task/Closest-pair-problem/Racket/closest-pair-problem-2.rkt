#lang racket
(struct point (x y) #:transparent)

(define (closest-pair ps)
  (check-type ps)
  (cond [(vector? ps) (if (> (vector-length ps) 1)
                          (closest-pair/sorted (vector-sort ps left?)
                                               (vector-sort ps below?))
                          (error 'closest-pair "2 or more points are needed" ps))]
        [(sequence? ps) (closest-pair (for/vector ([x (in-sequences ps)]) x))]
        [else (error 'closest-pair "closest pair only supports sequence types (excluding hash)")]))

;; accept any sequence type except hash
;; any other exclusions needed?
(define (check-type ps)
  (cond [(hash? ps) (error 'closest-pair "Hash tables are not supported")]
        [(sequence? ps) #t]
        [else (error 'closest-pair "Only sequence types are supported")]))

;; vector -> vector -> list
(define (closest-pair/sorted Px Py)
  (define L (vector-length Px))
  (cond [(= L 2) (vector->list Px)]
        [(= L 3) (apply min-pair (combinations (vector->list Px) 2))]
        [else (let*-values ([(Qx Rx) (vector-split-at Px (floor (/ L 2)))]
                            ; Rx-min is the left most point in Rx
                            [(Rx-min) (vector-ref Rx 0)]
                            ; instead of sorting Qx, Rx by y
                            ; - Qy are members of Py to left of Rx-min
                            ; - Ry are the remaining members of Py
                            [(Qy Ry) (vector-partition Py (curryr left? Rx-min))]
                            [(pair1) (closest-pair/sorted Qx Qy)]
                            [(pair2) (closest-pair/sorted Rx Ry)]
                            [(delta) (min (distance^2 pair1) (distance^2 pair2))]
                            [(pair3) (closest-split-pair Px Py delta)])
                ; pair3 is null when there are no split pairs closer than delta
                (min-pair pair1 pair2 pair3))]))

(define (closest-split-pair Px Py delta)
  (define Lp (vector-length Px))
  (define x-mid (point-x (vector-ref Px (floor (/ Lp 2)))))
  (define Sy (for/vector ([p (in-vector Py)]
                          #:when (< (abs (- (point-x p) x-mid)) delta))
               p))
  (define Ls (vector-length Sy))
  (define-values (_ best-pair)
    (for*/fold ([new-best delta]
                [new-best-pair null])
               ([i (in-range (sub1 Ls))]
                [j (in-range (+ i 1) (min (+ i 7) Ls))]
                [Sij (in-value (list (vector-ref Sy i)
                                     (vector-ref Sy j)))]
                [dij (in-value (distance^2 Sij))]
                #:when (< dij new-best))
      (values dij Sij)))
  best-pair)

;; helper procedures

;; same as partition except for vectors
;; it's critical to maintain the relative order of elements
(define (vector-partition Py pred)
  (define-values (left right)
    (for/fold ([Qy null]
               [Ry null])
              ([p (in-vector Py)])
      (if (pred p)
          (values (cons p Qy) Ry)
          (values Qy (cons p Ry)))))
  (values (list->vector (reverse left))
          (list->vector (reverse right))))

; is p1 (strictly) left of p2
(define (left? p1 p2)  (< (point-x p1) (point-x p2)))

; is p1 (strictly) below of p2
(define (below? p1 p2) (< (point-y p1) (point-y p2)))

;; return the pair with minimum distance
(define (min-pair . pairs)
  (argmin distance^2 pairs))

;; pairs are passed around as a list of 2 points
;; distance is only for comparison so no need to use sqrt
(define (distance^2 pair)
  (cond [(null? pair) +inf.0]
        [else (define a (first pair))
              (define b (second pair))
              (+ (sqr (- (point-x b) (point-x a)))
                 (sqr (- (point-y b) (point-y a))))]))

; points on a quadratic curve, shuffled
(define points
       (shuffle
        (for/list ([ i (in-range 1000)]) (point i (* i i)))))
(match-define (list (point p1x p1y) (point p2x p2y)) (closest-pair points))
(printf "Closest points on a quadratic curve (~a,~a) (~a,~a)\n" p1x p1y p2x p2y)
