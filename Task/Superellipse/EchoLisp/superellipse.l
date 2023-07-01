(lib 'plot)
(define (eaxpt x n) (expt (abs x) n))
(define (Ellie x y) (+ (eaxpt (// x 200) 2.5) (eaxpt (// y 200) 2.5) -1))

(plot-xy Ellie -400 -400)
    → (("x:auto" -400 400) ("y:auto" -400 400))
