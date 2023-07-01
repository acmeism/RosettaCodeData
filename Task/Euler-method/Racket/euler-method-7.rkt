(define (adams F h)
  (case-lambda
    ; first step using Runge-Kutta method
    [(x y) (append ((RK2 F h) x y) (list (F x y)))]
    [(x y f′)
     (let ([f (F x y)])
       (list (+ x h) (+ y (* 3/2 h f) (* -1/2 h f′)) f))]))
