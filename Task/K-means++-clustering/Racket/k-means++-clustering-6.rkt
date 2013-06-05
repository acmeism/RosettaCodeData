(require plot)

(define (show-clustering data k #:method (method k-means++))
  (define c (k-means data k #:initialization method))
  (display
   (plot
    (append
     (for/list ([d (clusterize data c)]
                [i (in-naturals)])
       (points d #:color i #:sym 'fullcircle1))
     (list (points c
                   #:sym 'fullcircle7
                   #:fill-color 'yellow
                   #:line-width 3)))
    #:title (format "Initializing by ~a" (object-name method)))))
