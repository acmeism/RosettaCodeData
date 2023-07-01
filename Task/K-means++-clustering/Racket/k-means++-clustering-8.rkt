(module+ test
  (define clouds
    (append
     (gaussian-cluster 1000 #:stdev 0.5 #:center #(0 0))
     (gaussian-cluster 1000 #:stdev 0.5 #:center #(2 3))
     (gaussian-cluster 1000 #:stdev 0.5 #:center #(2.5 -1))
     (gaussian-cluster 1000 #:stdev 0.5 #:center #(6 0))))

  ; using k-means++ method
  (show-clustering clouds 4)
  ; using standard k-means method
  (show-clustering clouds 4 #:method random-choice))
