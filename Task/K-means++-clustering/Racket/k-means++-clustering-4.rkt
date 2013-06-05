(define (fixed-point f x0 #:same-test [same? equal?])
  (let loop ([x x0] [fx (f x0)])
    (if (same? x fx) fx (loop fx (f fx)))))
