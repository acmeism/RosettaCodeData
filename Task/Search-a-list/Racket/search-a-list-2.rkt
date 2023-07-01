(define (index-last xs y)
  (for/last ([(x i) (in-indexed xs)]
             #:when (equal? x y))
    i))
