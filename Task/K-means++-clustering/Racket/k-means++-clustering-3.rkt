(define (euclidean-distance a b)
  (for/sum ([x (in-vector a)] [y (in-vector b)])
    (sqr (- x y))))

(define (manhattan-distance a b)
  (for/sum ([x (in-vector a)] [y (in-vector b)])
    (abs (- x y))))

(define metric (make-parameter euclidean-distance))
(define (distanse-to x) (curry (metric) x))
