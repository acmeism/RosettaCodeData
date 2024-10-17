(define-library (convex-hulls)

  (export convex-hull)

  (import (scheme base))
  (import (only (srfi 1) fold))
  (import (only (srfi 1) append!))
  (import (only (srfi 132) list-sort))
  (import (only (srfi 132) list-delete-neighbor-dups))

  (begin

    ;;
    ;; Andrew's monotone chain algorithm for the convex hull in a
    ;; plane.
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

    (define (point=? u v)
      (and (= (x@ u) (x@ v)) (= (y@ u) (y@ v))))

    (define (point<? u v)
      (let ((xu (x@ u))
            (xv (x@ v)))
        (or (< xu xv) (and (= xu xv) (< (y@ u) (y@ v))))))

    (define (convex-hull points-list)
      (let* ((points (list-delete-neighbor-dups
                      point=? (list-sort point<? points-list)))
             (n (length points)))
        (cond
         ((<= n 2) points)
         (else
          (let ((half-hull (make-vector n)))
            (define (cross-test pt j)
              (or (zero? j)
                  (let ((elem-j (vector-ref half-hull j))
                        (elem-j1 (vector-ref half-hull (- j 1))))
                    (positive? (cross (point- elem-j elem-j1)
                                      (point- pt elem-j1))))))
            (define (construct-half-hull points)
              (vector-set! half-hull 0 (car points))
              (vector-set! half-hull 1 (cadr points))
              (fold (lambda (pt j)
                      (let loop ((j j))
                        (if (cross-test pt j)
                            (let ((j1 (+ j 1)))
                              (vector-set! half-hull j1 pt)
                              j1)
                            (loop (- j 1)))))
                    1 (cddr points)))
            (let* ((lower-hull
                    ;; Leave out the last point, which is the same
                    ;; as the first point of the upper hull.
                    (let ((j (construct-half-hull points)))
                      (vector->list half-hull 0 j)))
                   (upper-hull
                    ;; Leave out the last point, which is the same
                    ;; as the first point of the lower hull.
                    (let ((j (construct-half-hull (reverse points))))
                      (vector->list half-hull 0 j))))
              (append! lower-hull upper-hull)))))))

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

(write (convex-hull example-points))
(newline)
