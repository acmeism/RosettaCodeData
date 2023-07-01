(module+ test
  (define 5d-data
    (append
     (gaussian-cluster 1000 #:dim 5 #:center #(2 0 0 0 0))
     (gaussian-cluster 1000 #:dim 5 #:center #(0 2 0 0 0))
     (gaussian-cluster 1000 #:dim 5 #:center #(0 0 2 0 0))
     (gaussian-cluster 1000 #:dim 5 #:center #(0 0 0 2 0))
     (gaussian-cluster 1000 #:dim 5 #:center #(0 0 0 0 2))))

  (define centroids (k-means 5d-data 5))

  (map (curry vector-map round) centroids))
