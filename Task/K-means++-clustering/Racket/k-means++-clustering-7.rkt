(module+ test
  (define circle (uniform-cluster 30000))
  ; using k-means++ method
  (show-clustering circle 6)
  ; using standard k-means method
  (show-clustering circle 6 #:method random-choice)
  ; using manhattan distance
  (parameterize ([metric manhattan-distance])
    (show-clustering circle 6)))
