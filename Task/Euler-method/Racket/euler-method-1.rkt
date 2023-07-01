(define (ODE-solve f init
                   #:x-max x-max
                   #:step h
                   #:method (method euler))
  (reverse
   (iterate-while (λ (x . y) (<= x x-max)) (method f h) init)))
