(define-library (convex-hulls)

  (export vector-convex-hull)
  (export list-convex-hull)

  (import (scheme base))
  (import (srfi 132))                   ; Sorting.

  (begin

    ;;
    ;; The implementation is based on Andrew's monotone chain
    ;; algorithm, and is adapted from a Fortran implementation I wrote
    ;; myself in 2011.
    ;;
    ;; For a description of the algorithm, see
    ;; https://en.wikibooks.org/w/index.php?title=Algorithm_Implementation/Geometry/Convex_hull/Monotone_chain&stableid=4016938
    ;;

    (define x@ car)
    (define y@ cadr)

    (define (cross u v)
      ;; Cross product (as a signed scalar).
      (- (* (x@ u) (y@ v)) (* (y@ u) (x@ v))))

    (define (point- u v)
      (list (- (x@ u) (x@ v)) (- (y@ u) (y@ v))))

    (define (sort-points-vector points-vector)
      ;; Ascending sort on x-coordinates, followed by ascending sort
      ;; on y-coordinates.
      (vector-sort (lambda (u v)
                     (or (< (x@ u) (x@ v))
                         (and (= (x@ u) (x@ v))
                              (< (y@ u) (y@ v)))))
                   points-vector))

    (define (construct-lower-hull sorted-points-vector)
      (let* ((pt sorted-points-vector)
             (n (vector-length pt))
             (hull (make-vector n))
             (j 1))
        (vector-set! hull 0 (vector-ref pt 0))
        (vector-set! hull 1 (vector-ref pt 1))
        (do ((i 2 (+ i 1)))
            ((= i n))
          (let inner-loop ()
            (if (or (zero? j)
                    (positive?
                     (cross (point- (vector-ref hull j)
                                    (vector-ref hull (- j 1)))
                            (point- (vector-ref pt i)
                                    (vector-ref hull (- j 1))))))
                (begin
                  (set! j (+ j 1))
                  (vector-set! hull j (vector-ref pt i)))
                (begin
                  (set! j (- j 1))
                  (inner-loop)))))
        (values (+ j 1) hull)))         ; Hull size, hull points.

    (define (construct-upper-hull sorted-points-vector)
      (let* ((pt sorted-points-vector)
             (n (vector-length pt))
             (hull (make-vector n))
             (j 1))
        (vector-set! hull 0 (vector-ref pt (- n 1)))
        (vector-set! hull 1 (vector-ref pt (- n 2)))
        (do ((i (- n 3) (- i 1)))
            ((= i -1))
          (let inner-loop ()
            (if (or (zero? j)
                    (positive?
                     (cross (point- (vector-ref hull j)
                                    (vector-ref hull (- j 1)))
                            (point- (vector-ref pt i)
                                    (vector-ref hull (- j 1))))))
                (begin
                  (set! j (+ j 1))
                  (vector-set! hull j (vector-ref pt i)))
                (begin
                  (set! j (- j 1))
                  (inner-loop)))))
        (values (+ j 1) hull)))         ; Hull size, hull points.

    (define (construct-hull sorted-points-vector)
      ;; Notice that the lower and upper hulls could be constructed in
      ;; parallel.
      (let-values (((lower-hull-size lower-hull)
                    (construct-lower-hull sorted-points-vector))
                   ((upper-hull-size upper-hull)
                    (construct-upper-hull sorted-points-vector)))
        (let* ((hull-size (+ lower-hull-size upper-hull-size -2))
               (hull (make-vector hull-size)))
          (vector-copy! hull 0 lower-hull 0 (- lower-hull-size 1))
          (vector-copy! hull (- lower-hull-size 1) upper-hull
                        0 (- upper-hull-size 1))
          hull)))

    (define (vector-convex-hull points)
      (let* ((points-vector (if (vector? points)
                                points
                                (list->vector points)))
             (sorted-points-vector
              (vector-delete-neighbor-dups
               equal?
               (sort-points-vector points-vector))))
        (if (<= (vector-length sorted-points-vector) 2)
            sorted-points-vector
            (construct-hull sorted-points-vector))))

    (define (list-convex-hull points)
      (vector->list (vector-convex-hull points)))

    )) ;; end of library convex-hulls.

;;
;; A demonstration.
;;

(import (scheme base))
(import (scheme write))
(import (convex-hulls))

(define example-points
  '((16 3) (12 17) (0 6) (-4 -6) (16 6)
    (16 -7) (16 -3) (17 -4) (5 19) (19 -8)
    (3 16) (12 13) (3 -4) (17 5) (-3 15)
    (-3 -9) (0 11) (-9 -3) (-4 -2) (12 10)))

(write (list-convex-hull example-points))
(newline)
