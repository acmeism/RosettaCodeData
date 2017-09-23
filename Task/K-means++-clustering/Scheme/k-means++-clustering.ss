(import (scheme base) ; headers for R7RS Scheme
        (scheme file)
        (scheme inexact)
        (scheme write)
        (srfi 1 lists)
        (srfi 27 random-bits))

;; calculate euclidean distance between points, any dimension
(define (euclidean-distance pt1 pt2)
  (sqrt (apply + (map (lambda (x y) (square (- x y))) pt1 pt2))))

;; input
;; - K: the target number of clusters K
;; - data: a list of points in the Cartesian plane
;; output
;; - a list of K centres
(define (kmeans++ K data)
  (define (select-uniformly data)
    (let loop ((index (random-integer (length data))) ; uniform selection of index
               (rem data)
               (front '()))
      (if (zero? index)
        (values (car rem) (append (reverse front) (cdr rem)))
        (loop (- index 1) (cdr rem) (cons (car rem) front)))))
  ;
  (define (select-weighted centres data)
    (define (distance-to-nearest datum)
      (apply min (map (lambda (c) (euclidean-distance c datum)) centres)))
    ;
    (let* ((weights (map (lambda (d) (square (distance-to-nearest d))) data))
           (target-weight (* (apply + weights) (random-real))))
      (let loop ((rem data)
                 (front '())
                 (weight-sum 0.0)
                 (wgts weights))
        (if (or (>= weight-sum target-weight) (null? (cdr rem)))
          (values (car rem) (append (reverse front) (cdr rem)))
          (loop (cdr rem)
                (cons (car rem) front)
                (+ weight-sum (car wgts))
                (cdr weights))))))
  ;
  (let-values (((pt rem) (select-uniformly data)))
              (let loop ((centres (list pt))
                         (items rem))
                (if (= (length centres) K)
                  centres
                  (let-values (((pt rem) (select-weighted centres items)))
                              (loop (cons pt centres)
                                    rem))))))

;; assign a point into a cluster
;; input: a point and a list of cluster centres
;; output: index of cluster centre
(define (assign-cluster pt centres)
  (let* ((distances (map (lambda (centre) (euclidean-distance centre pt)) centres))
         (smallest (apply min distances)))
    (list-index (lambda (d) (= d smallest)) distances)))

;; input
;; - num: the number of clusters K
;; - data: a list of points in the Cartesian plane
;; output
;; - list of K centres
(define (cluster K data)
  (define (centroid-for-cluster i assignments)
    (let* ((cluster (map cadr (filter (lambda (a-d) (= (car a-d) i)) (zip assignments data))))
           (length-cluster (length cluster)))
      ; compute centroid for cluster
      (map (lambda (vals) (/ (apply + vals) length-cluster)) (apply zip cluster))))
  ;
  (define (update-centres assignments)
    (map (lambda (i) (centroid-for-cluster i assignments)) (iota K)))
  ;
  (let ((initial-centres (kmeans++ K data)))
    (let loop ((centres initial-centres)
               (assignments (map (lambda (datum) (assign-cluster datum initial-centres)) data)))
      (let* ((new-centres (update-centres assignments))
             (new-assignments (map (lambda (datum) (assign-cluster datum new-centres)) data)))
        (if (equal? assignments new-assignments)
          new-centres
          (loop new-centres new-assignments))))))

;; using eps output, based on that in C - only works for 2D points
(define (save-as-eps filename data clusters K)
  (when (file-exists? filename) (delete-file filename))
  (with-output-to-file
    filename
    (lambda ()
      (let* ((W 400)
             (H 400)
             (colours (make-vector (* 3 K) 0.0))
             (max-x (apply max (map car data)))
             (min-x (apply min (map car data)))
             (max-y (apply max (map cadr data)))
             (min-y (apply min (map cadr data)))
             (scale (min (/ W (- max-x min-x))
                         (/ H (- max-y min-y))))
             (cx (/ (+ max-x min-x) 2))
             (cy (/ (+ max-y min-y) 2)))

        ;; set up colours
        (for-each
          (lambda (i)
            (vector-set! colours (+ (* i 3) 0) (inexact (/ (modulo (* 3 (+ i 1)) 11) 11)))
            (vector-set! colours (+ (* i 3) 1) (inexact (/ (modulo (* 7 i) 11) 11)))
            (vector-set! colours (+ (* i 3) 2) (inexact (/ (modulo (* 9 i) 11) 11))))
          (iota K))

        (display ;; display header
          (string-append
            "%!PS-Adobe-3.0\n%%BoundingBox: -5 -5 "
            (number->string (+ 10 W)) " " (number->string (+ 10 H)) "\n"
            "/l {rlineto} def /m {rmoveto} def\n"
            "/c { .25 sub exch .25 sub exch .5 0 360 arc fill } def\n"
            "/s { moveto -2 0 m 2 2 l 2 -2 l -2 -2 l closepath "
            "	gsave 1 setgray fill grestore gsave 3 setlinewidth"
            " 1 setgray stroke grestore 0 setgray stroke }def\n"))

        ;; display points
        (for-each ; top loop runs over the clusters
          (lambda (i)
            (display
              (string-append (number->string (vector-ref colours (* i 3)))
                             " "
                             (number->string (vector-ref colours (+ (* i 3) 1)))
                             " "
                             (number->string (vector-ref colours (+ (* i 3) 2)))
                             " setrgbcolor\n"))
            (for-each ;loop over points in cluster
              (lambda (pt)
                (when (= i (assign-cluster pt clusters))
                  (display
                    (string-append (number->string (+ (* (- (car pt) cx) scale) (/ W 2)))
                                   " "
                                   (number->string (+ (* (- (cadr pt) cy) scale) (/ H 2)))
                                   " c\n"))))
              data)
            (let ((center (list-ref clusters i))) ; display cluster centre
              (display
                (string-append "\n0 setgray "
                               (number->string (+ (* (- (car center) cx) scale) (/ W 2)))
                               " "
                               (number->string (+ (* (- (cadr center) cy) scale) (/ H 2)))
                               " s\n"))))
          (iota K))
        (display "\n%%EOF")))))

;; extra credit 1: creates a list of n random points in n-D unit square
(define (make-data num-points num-dimensions)
  (random-source-randomize! default-random-source)
  (map (lambda (i) (list-tabulate num-dimensions (lambda (i) (random-real)))) (iota num-points)))

;; extra credit 2, uses eps visualisation to display result
(define (tester-1 num-points K)
  (let ((data (make-data num-points 2)))
    (save-as-eps "clusters-1.eps" data (cluster K data) K)))

;; extra credit 3: uses radians instead to make data
(define (tester-2 num-points K radius)
  (random-source-randomize! default-random-source)
  (let ((data (map (lambda (i)
                     (let ((ang (* (random-real) 2 (* 4 (atan 1))))
                           (rad (* radius (random-real))))
                       (list (* rad (cos ang)) (* rad (sin ang)))))
                   (iota num-points))))
    ;; extra credit 2, uses eps visualisation to display result
    (save-as-eps "clusters-2.eps" data (cluster K data) K)))

;; extra credit 4: arbitrary dimensions - already handled, as all points are lists
(define (tester-3 num-points K num-dimensions)
  (display "Results:\n")
  (display (cluster K (make-data num-points num-dimensions)))
  (newline))

(tester-1 30000 6)
(tester-2 30000 6 10)
(tester-3 30000 6 5)
