(define (m-mult m1 m2)
  (for/list ([r m1])
    (for/list ([c (apply map list m2)])
      (apply + (map * r c)))))
