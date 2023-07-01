;; Plots the Voronoi diagram as a contour plot of
;; the classification function built for a set of points
(define (plot-Voronoi-diagram2 point-list)
  (define n (length point-list))
  (define F (classification-function point-list))
  (plot
   (list
    (contour-intervals (compose F vector) 0 1 0 1
                       #:samples 300
                       #:levels n
                       #:colors (range n)
                       #:contour-styles '(solid)
                       #:alphas '(1))
    (points point-list #:sym 'fullcircle3))))

;; For a set of centroids returns a function
;; which finds the index of the centroid nearest
;; to a given point
(define (classification-function centroids)
  (define tbl
    (for/hash ([p (in-list centroids)] [i (in-naturals)])
      (values p i)))
  (λ (x)
    (hash-ref tbl (argmin (curry (metric) x) centroids))))
