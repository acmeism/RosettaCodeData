(define (RK2 F h)
  (λ (x y)
    (list (+ x h) (+ y (* h (F (+ x (* 1/2 h))
                               (+ y (* 1/2 h (F x y)))))))))
