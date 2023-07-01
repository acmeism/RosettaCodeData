#lang racket

(require plot)

;; Performs clustering of points in a grid
;; using the nearest neigbour approach and shows
;; clusters in different colors
(define (plot-Voronoi-diagram point-list)
  (define pts
    (for*/list ([x (in-range 0 1 0.005)]
                [y (in-range 0 1 0.005)])
      (vector x y)))

  (define clusters (clusterize pts point-list))

  (plot
   (append
    (for/list ([r (in-list clusters)] [i (in-naturals)])
      (points (rest r) #:color i #:sym 'fullcircle1))
    (list (points point-list #:sym 'fullcircle5 #:fill-color 'white)))))

;; Divides the set of points into clusters
;; using given centroids
(define (clusterize data centroids)
  (for*/fold ([res (map list centroids)]) ([x (in-list data)])
    (define c (argmin (curryr (metric) x) centroids))
    (dict-set res c (cons x (dict-ref res c)))))
