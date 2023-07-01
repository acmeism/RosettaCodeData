;;
;; For R7RS-small plus very limited R7RS-large. The implementation
;; must support libraries, Unicode identifiers, IEEE arithmetic, etc.
;;
;; These will work:
;;
;;     gosh -r7 file.scm
;;     csc -X r7rs -R r7rs file.scm
;;

(define-library (spower quadratic)
  (export spower spower?
          spower-c0 spower-c1 spower-c2
          plane-curve plane-curve?
          plane-curve-x plane-curve-y
          control-points->plane-curve
          spower-eval plane-curve-eval
          center-coef critical-points)

  (import (scheme base)
          (scheme case-lambda)
          (srfi 132) ;; R7RS-large name: (scheme sort)
          )

  (begin

    (define-record-type <spower>
      (spower c0 c1 c2)
      spower?
      (c0 spower-c0)
      (c1 spower-c1)
      (c2 spower-c2))

    (define-record-type <plane-curve>
      (plane-curve x y)
      plane-curve?
      (x plane-curve-x)
      (y plane-curve-y))

    (define (point->values point)
      ;; A bit of playfulness on my part: a few ways to write an
      ;; (x,y)-point: (cons x y), (list x y), (vector x y), and their
      ;; equivalents.
      (cond ((and (pair? point) (real? (car point)))
             (cond ((real? (cdr point))
                    (values (car point) (cdr point)))
                   ((and (real? (cadr point)) (null? (cddr point)))
                    (values (car point) (cadr point)))
                   (else (error "not a plane point" point))))
            ((and (vector? point) (= (vector-length point) 2))
             (values (vector-ref point 0) (vector-ref point 1)))
            (else (error "not a plane point" point))))

    (define control-points->plane-curve
      ;; A bit more playfulness: the control points can be given
      ;; separately, as a list, or as a vector.
      (case-lambda
        ((pt0 pt1 pt2)
         (let-values
             (((cx0 cy0) (point->values pt0))
              ((cx1 cy1) (point->values pt1))
              ((cx2 cy2) (point->values pt2)))
           (plane-curve (spower cx0 (- (+ cx1 cx1) cx0 cx2) cx2)
                        (spower cy0 (- (+ cy1 cy1) cy0 cy2) cy2))))
        ((pt-list-or-vector)
         (apply control-points->plane-curve
                (if (vector? pt-list-or-vector)
                    (vector->list pt-list-or-vector)
                    pt-list-or-vector)))))

    (define (spower-eval poly t)
      ;; Evaluate the polynomial at t.
      (let ((c0 (spower-c0 poly))
            (c1 (spower-c1 poly))
            (c2 (spower-c2 poly)))
        (+ (* (+ c0 (* c1 t)) (- 1 t)) (* c2 t))))

    (define (plane-curve-eval curve t)
      ;; Evaluate the plane curve at t, returning x and y as multiple
      ;; values.
      (values (spower-eval (plane-curve-x curve) t)
              (spower-eval (plane-curve-y curve) t)))

    (define (center-coef poly t0 t1)
      ;; Return the center coefficient for the [t0,t1] portion. (The
      ;; other coefficients can be found with the spower-eval
      ;; procedured.)
      (let ((c1 (spower-c1 poly)))
        (* c1 (+ (* (- t1 t0 t0) t1) (* t0 t0)))))

    (define (critical-points poly-or-curve)
      ;; Return a sorted list of independent variable values for the
      ;; critical points that lie in (0,1). Duplicates are removed.
      (cond ((plane-curve? poly-or-curve)
             (let ((X (plane-curve-x poly-or-curve))
                   (Y (plane-curve-y poly-or-curve)))
               (list-delete-neighbor-dups
                =
                (list-sort < (append (critical-points X)
                                     (critical-points Y))))))
            ((spower? poly-or-curve)
             (let ((c0 (spower-c0 poly-or-curve))
                   (c1 (spower-c1 poly-or-curve))
                   (c2 (spower-c2 poly-or-curve)))
               (cond ((zero? c1) '())   ; The spline is linear.
                     ((= c0 c2) '(1/2)) ; The spline is "pulse-like".
                     (else
                      ;; The root of the derivative is the critical
                      ;; point.
                      (let ((t (/ (- (+ c2 c1) c0) (+ c1 c1))))
                        (if (and (positive? t) (< t 1))
                            (list t)
                            '()))))))
            (else (error "not an spower polynomial or plane-curve"
                         poly-or-curve))))

    )) ;; end library (spower quadratic)

(define-library (spower quadratic intersections)

  ;; Parameters. (That is, variables whose value settings have
  ;; "dynamic" rather than lexical scope.)
  (export *tolerance-norm*
          *flatness-tolerance*
          *absolute-tolerance*)

  (export find-intersection-parameters)

  (import (scheme base)
          (scheme case-lambda)
          (scheme inexact)
          (spower quadratic)
          (srfi 144) ;; R7RS-large name: (scheme flonum)
          )

  (begin

    (define-record-type <portion>
      (make-portion curve t0 t1 endpt0 endpt1)
      portion?
      (curve curve@)
      (t0 t0@)
      (t1 t1@)
      (endpt0 endpt0@)
      (endpt1 endpt1@))

    (define (curve-eval curve t)
      (call-with-values (lambda () (plane-curve-eval curve t))
        cons))

    (define (0<=x<=1 x)
      (and (<= 0 x) (<= x 1)))

    (define (lerp t a b)                ; "linear interpolation"
      (+ (* (- 1 t) a) (* t b)))

    (define (bisect-portion portion)
      ;; Bisect portion and return the two new portions as multiple
      ;; values.
      (let ((curve (curve@ portion))
            (t0 (t0@ portion))
            (t1 (t1@ portion))
            (pt0 (endpt0@ portion))
            (pt1 (endpt1@ portion)))
        (let* ((t½ (* 1/2 (+ t0 t1)))
               (pt½ (curve-eval curve t½)))
          (values (make-portion curve t0 t½ pt0 pt½)
                  (make-portion curve t½ t1 pt½ pt1)))))

    (define (check-norm x)
      (cond ((and (positive? x) (infinite? x)) x)
            ((= x 1) (exact x))
            ((= x 2) (exact x))
            (else (error "not a norm we can handle" x))))

    (define (check-flatness-tolerance x)
      (cond ((zero? x) x)
            ((positive? x) x)
            (else
             (error
              "not a flatness (relative) tolerance we can handle"
              x))))

    (define (check-absolute-tolerance x)
      (cond ((zero? x) x)
            ((positive? x) x)
            (else (error "not an absolute tolerance we can handle"
                         x))))

    (define *tolerance-norm*
      ;; To be fancier, we could take strings such as "taxicab",
      ;; "euclidean", "max", etc., as arguments to the
      ;; constructor. But here we are taking only the value of p in a
      ;; p-norm (= pth root of the sum of |x| raised p and |y| raised
      ;; p), and then only for p = 1, 2, +inf.0.
      (make-parameter +inf.0 check-norm)) ;; Default is the max norm.

    ;; A relative tolerance. This setting seems to me rather strict
    ;; for a lot of applications. But you can override it.
    (define *flatness-tolerance*
      (make-parameter 0.0001 check-flatness-tolerance))

    (define *absolute-tolerance*
      (make-parameter (* 50 fl-epsilon) check-absolute-tolerance))

    (define (compare-lengths norm ax ay bx by)
      (define (compare-lengths-1-norm)
        (let ((‖a‖ (+ (abs ax) (abs ay)))
              (‖b‖ (+ (abs bx) (abs by))))
          (cond ((< ‖a‖ ‖b‖) -1)
                ((> ‖a‖ ‖b‖) 1)
                (else 0))))
      (define (compare-lengths-2-norm)
        (let ((‖a‖² (* ax ay))
              (‖b‖² (* bx by)))
          (cond ((< ‖a‖² ‖b‖²) -1)
                ((> ‖a‖² ‖b‖²) 1)
                (else 0))))
      (define (compare-lengths-inf-norm)
        (let ((‖a‖ (max (abs ax) (abs ay)))
              (‖b‖ (max (abs bx) (abs by))))
          (cond ((< ‖a‖ ‖b‖) -1)
                ((> ‖a‖ ‖b‖) 1)
                (else 0))))
      (cond ((= norm 1) (compare-lengths-1-norm))
            ((= norm 2) (compare-lengths-2-norm))
            (else (compare-lengths-inf-norm))))

    (define (compare-to-tol norm ax ay tol)
      (define (compare-to-tol-1-norm)
        (let ((‖a‖ (+ (abs ax) (abs ay))))
          (cond ((< ‖a‖ tol) -1)
                ((> ‖a‖ tol) 1)
                (else 0))))
      (define (compare-to-tol-2-norm)
        (let ((‖a‖² (* ax ay))
              (tol² (* tol tol)))
          (cond ((< ‖a‖² tol²) -1)
                ((> ‖a‖² tol²) 1)
                (else 0))))
      (define (compare-to-tol-inf-norm)
        (let ((‖a‖ (max (abs ax) (abs ay))))
          (cond ((< ‖a‖ tol) -1)
                ((> ‖a‖ tol) 1)
                (else 0))))
      (cond ((= norm 1) (compare-to-tol-1-norm))
            ((= norm 2) (compare-to-tol-2-norm))
            (else (compare-to-tol-inf-norm))))

    (define (flat-enough? portion norm rtol atol)
      ;; Is the portion flat enough or small enough to be treated as
      ;; if it were a line segment?

      ;; The degree-2 s-power polynomials are 1-t, t(1-t), t. We
      ;; want to remove the terms in t(1-t). The maximum of t(1-t)
      ;; is 1/4, reached at t=1/2. That accounts for the 1/4 in the
      ;; following.
      (let ((curve (curve@ portion))
            (t0 (t0@ portion))
            (t1 (t1@ portion))
            (pt0 (endpt0@ portion))
            (pt1 (endpt1@ portion)))
        (let ((X (plane-curve-x curve))
              (Y (plane-curve-y curve)))
          (let ((errx (* 1/4 (center-coef X t0 t1)))
                (erry (* 1/4 (center-coef Y t0 t1)))
                (testx (* rtol (- (car pt1) (car pt0))))
                (testy (* rtol (- (cdr pt1) (cdr pt0)))))
            (or (<= (compare-lengths norm errx erry testx testy) 0)
                (<= (compare-to-tol norm errx erry atol) 0))))))

    (define (rectangles-overlap a0 a1 b0 b1)
      ;;
      ;; Do the rectangles with corners at (a0,a1) and (b0,b1) have
      ;; overlapping interiors or edges? The corner points must be
      ;; represented as cons-pairs, with x as the car and y as the
      ;; cdr.
      ;;
      ;; (A side note: I had thought for a few hours that checking
      ;; only for overlapping interiors offered some advantages, but I
      ;; changed my mind.)
      ;;
      (let ((a0x (min (car a0) (car a1)))
            (a1x (max (car a0) (car a1)))
            (b0x (min (car b0) (car b1)))
            (b1x (max (car b0) (car b1))))
        (cond ((< b1x a0x) #f)
              ((< a1x b0x) #f)
              (else
               (let ((a0y (min (cdr a0) (cdr a1)))
                     (a1y (max (cdr a0) (cdr a1)))
                     (b0y (min (cdr b0) (cdr b1)))
                     (b1y (max (cdr b0) (cdr b1))))
                 (cond ((< b1y a0y) #f)
                       ((< a1y b0y) #f)
                       (else #t)))))))

    (define (segment-parameters a0 a1 b0 b1)
      ;; Return (as multiple values) the respective [0,1] parameters
      ;; of line segments (a0,a1) and (b0,b1), for their intersection
      ;; point. Return #f and #f if there is no intersection. The
      ;; endpoints must be represented as cons-pairs, with x as the
      ;; car and y as the cdr.
      (let ((a0x (car a0)) (a0y (cdr a0))
            (a1x (car a1)) (a1y (cdr a1))
            (b0x (car b0)) (b0y (cdr b0))
            (b1x (car b1)) (b1y (cdr b1)))
        (let ((axdiff (- a1x a0x))
              (aydiff (- a1y a0y))
              (bxdiff (- b1x b0x))
              (bydiff (- b1y b0y)))
          (let* ((denom (- (* axdiff bydiff) (* aydiff bxdiff)))
                 (anumer (+ (* bxdiff a0y)
                            (- (* bydiff a0x))
                            (* b0x b1y)
                            (- (* b1x b0y))))
                 (ta (/ anumer denom)))
            (if (not (0<=x<=1 ta))
                (values #f #f)
                (let* ((bnumer (- (+ (* axdiff b0y)
                                     (- (* aydiff b0x))
                                     (* a0x a1y)
                                     (- (* a1x a0y)))))
                       (tb (/ bnumer denom)))
                  (if (not (0<=x<=1 tb))
                      (values #f #f)
                      (values ta tb))))))))

    (define (initial-workload P Q)
      ;; Generate an initial workload from plane curves P and Q. One
      ;; does this by splitting the curves at their critical points
      ;; and constructing the Cartesian product of the resulting
      ;; portions. The workload is a list of cons-pairs of
      ;; portions. (The list represents a set, but the obvious place,
      ;; from which to get an arbitrary pair to work on next, is the
      ;; head of the list. Thus the list effectively is a stack.)
      (define (t->point curve) (lambda (t) (curve-eval curve t)))
      (let* ((pparams0 `(0 ,@(critical-points P) 1))
             (pvalues0 (map (t->point P) pparams0))
             (qparams0 `(0 ,@(critical-points Q) 1))
             (qvalues0 (map (t->point Q) qparams0)))
        (let loop ((pparams pparams0) (pvalues pvalues0)
                   (qparams qparams0) (qvalues qvalues0)
                   (workload '()))
          (cond ((null? (cdr pparams)) workload)
                ((null? (cdr qparams))
                 (loop (cdr pparams) (cdr pvalues)
                       qparams0 qvalues0 workload))
                (else
                 (let ((pportion
                        (make-portion P (car pparams) (cadr pparams)
                                      (car pvalues) (cadr pvalues)))
                       (qportion
                        (make-portion Q (car qparams) (cadr qparams)
                                      (car qvalues) (cadr qvalues))))
                   (loop pparams pvalues (cdr qparams) (cdr qvalues)
                         (cons (cons pportion qportion)
                               workload))))))))

    (define (params≅? a b)
      (and (≅? (car a) (car b))
           (≅? (cdr a) (cdr b))))

    (define (≅? x y)
      ;; I do not know this test is any better, for THIS algorithm,
      ;; than an exact equality test. But it is no worse.
      (<= (abs (- x y)) (* 0.5 fl-epsilon (max (abs x) (abs y)))))

    (define (include-params tp tq lst)
      (let ((params (cons tp tq)))
        (if (not (member params lst params≅?))
            (cons params lst)
            lst)))

    (define find-intersection-parameters
      (case-lambda
        ((P Q) (find-intersection-parameters P Q #f #f #f))
        ((P Q norm) (find-intersection-parameters P Q norm #f #f))
        ((P Q norm rtol) (find-intersection-parameters
                          P Q norm rtol #f))
        ((P Q norm rtol atol)
         (let ((norm (check-norm
                      (or norm (*tolerance-norm*))))
               (rtol (check-flatness-tolerance
                      (or rtol (*flatness-tolerance*))))
               (atol (check-absolute-tolerance
                      (or atol (*absolute-tolerance*)))))
           (%%find-intersection-parameters P Q norm rtol atol)))))

    (define (%%find-intersection-parameters P Q norm rtol atol)
      (let loop ((workload (initial-workload P Q))
                 (params '()))
        (if (null? workload)
            params
            (let ((pportion (caar workload))
                  (qportion (cdar workload))
                  (workload (cdr workload)))
              (if (not (rectangles-overlap (endpt0@ pportion)
                                           (endpt1@ pportion)
                                           (endpt0@ qportion)
                                           (endpt1@ qportion)))
                  (loop workload params)
                  (if (flat-enough? pportion norm rtol atol)
                      (if (flat-enough? qportion norm rtol atol)
                          (let-values
                              (((tp tq)
                                (segment-parameters
                                 (endpt0@ pportion)
                                 (endpt1@ pportion)
                                 (endpt0@ qportion)
                                 (endpt1@ qportion))))
                            (if tp
                                (let* ((tp0 (t0@ pportion))
                                       (tp1 (t1@ pportion))
                                       (tq0 (t0@ qportion))
                                       (tq1 (t1@ qportion))
                                       (tp (lerp tp tp0 tp1))
                                       (tq (lerp tq tq0 tq1)))
                                  (loop workload (include-params
                                                  tp tq params)))
                                (loop workload params)))
                          (let-values (((qport1 qport2)
                                        (bisect-portion qportion)))
                            (loop `(,(cons pportion qport1)
                                    ,(cons pportion qport2)
                                    . ,workload)
                                  params)))
                      (if (flat-enough? qportion norm rtol atol)
                          (let-values (((pport1 pport2)
                                        (bisect-portion pportion)))
                            (loop `(,(cons pport1 qportion)
                                    ,(cons pport2 qportion)
                                    . ,workload)
                                  params))
                          (let-values (((pport1 pport2)
                                        (bisect-portion pportion))
                                       ((qport1 qport2)
                                        (bisect-portion qportion)))
                            (loop `(,(cons pport1 qport1)
                                    ,(cons pport1 qport2)
                                    ,(cons pport2 qport1)
                                    ,(cons pport2 qport2)
                                    . ,workload)
                                  params)))))))))

    )) ;; end library (spower quadratic intersections)

(import (scheme base)
        (scheme write)
        (spower quadratic)
        (spower quadratic intersections)
        (srfi 132) ;; R7RS-large name: (scheme sort)
        )

(define P (control-points->plane-curve '((-1 0) (0 10) (1 0))))
(define Q (control-points->plane-curve '((2 1) (-8 2) (2 3))))

;; Sort the results by the parameters for P. Thus the intersection
;; points will be sorted left to right.
(define params (list-sort (lambda (tpair1 tpair2)
                            (< (car tpair1) (car tpair2)))
                          (find-intersection-parameters P Q)))
(for-each
 (lambda (pair)
   (let ((tp (car pair))
         (tq (cdr pair)))
     (let-values (((ax ay) (plane-curve-eval P tp))
                  ((bx by) (plane-curve-eval Q tq)))
       (display (inexact tp)) (display "\t(")
       (display (inexact ax)) (display ", ")
       (display (inexact ay)) (display ") \t")
       (display (inexact tq)) (display "\t(")
       (display (inexact bx)) (display ", ")
       (display (inexact by)) (display ")\n"))))
 params)
