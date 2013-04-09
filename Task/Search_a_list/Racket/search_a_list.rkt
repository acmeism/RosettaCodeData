(define (index xs y)
  (for/first ([(x i) (in-indexed xs)]
              #:when (equal? x y))
    i))
