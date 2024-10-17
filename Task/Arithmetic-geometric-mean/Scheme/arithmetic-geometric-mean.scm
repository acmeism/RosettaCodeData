(define agm
  (case-lambda
    ((a0 g0) ; call again with default value for tolerance
     (agm a0 g0 1e-8))
    ((a0 g0 tolerance) ; called with three arguments
     (do ((a a0 (* (+ a g) 1/2))
          (g g0 (sqrt (* a g))))
       ((< (abs (- a g)) tolerance) a)))))

(display (agm 1 (/ 1 (sqrt 2)))) (newline)
