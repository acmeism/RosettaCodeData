(define (euler F h)
  (λ (x y) (list (+ x h) (+ y (* h (F x y))))))
