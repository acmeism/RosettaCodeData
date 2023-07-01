(define (dot-product x y)
  (apply + (map * x y)))

(println (dot-product '(1 3 -5) '(4 -2 -1)))
