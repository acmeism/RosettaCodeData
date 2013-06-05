> (require plot)
> (plot
   (map (λ (h c)
          (lines
           (ODE-solve newton-cooling '(0 100) #:x-max 100 #:step h)
           #:color c #:label (format "h=~a" h)))
        '(10 5 1)
        '(red blue black))
   #:legend-anchor 'top-right)
