> (require plot)
> (plot (list (function exact-solution 0 10 #:label "Exact solution")
              (points numeric-solution #:label "Runge-Kutta method"))
   #:x-label "t" #:y-label "y(t)")
