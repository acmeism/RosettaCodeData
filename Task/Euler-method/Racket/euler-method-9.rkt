> (define (solve-newton-cooling-by m)
    (ODE-solve newton-cooling '(0 100)
               #:x-max 100 #:step 10 #:method m))
> (plot
   (list
    (function (λ (t) (+ 20 (* 80 (exp (* -0.07 t))))) 0 100
              #:color 'black #:label "analytical")
    (lines (solve-newton-cooling-by euler)
           #:color 'red #:label "Euler")
    (lines (solve-newton-cooling-by RK2)
           #:color 'blue #:label "Runge-Kutta")
    (lines (solve-newton-cooling-by adams)
           #:color 'purple #:label "Adams")
    (points (solve-newton-cooling-by (adaptive euler 0.5))
            #:color 'red #:label "Adaptive Euler")
    (points (solve-newton-cooling-by (adaptive RK2 0.5))
            #:color 'blue #:label "Adaptive Runge-Kutta"))
   #:legend-anchor 'top-right)
