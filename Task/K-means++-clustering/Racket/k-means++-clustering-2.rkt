;; picks k points from a dataset randomly
(define (random-choice data k)
  (for/list ([i (in-range k)])
    (list-ref data (random (length data)))))

;; uses k-means++ algorithm
(define (k-means++ data k)
  (for/fold ([centroids (random-choice data 1)]) ([i (in-range (- k 1))])
    (define weights
      (for/list ([x (in-list data)])
        (apply min (map (distanse-to x) centroids))))
    (define new-centroid
      (sample (discrete-dist data weights)))
    (cons new-centroid centroids)))
