(define ((adaptive method ε) F h0)
  (case-lambda
    [(x y) (((adaptive method ε) F h0) x y h0)]
    [(x y h)
     (match-let* ([(list x0 y0) ((method F h) x y)]
                  [(list x1 y1) ((method F (/ h 2)) x y)]
                  [(list x1 y1) ((method F (/ h 2)) x1 y1)]
                  [τ  (abs (- y1 y0))]
                  [h′ (if (< τ ε) (min h h0) (* 0.9 h (/ ε τ)))])
       (list x1 (+ y1 τ) (* 2 h′)))]))
