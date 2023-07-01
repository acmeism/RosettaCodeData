(define (LegendreP n x)
  (let compute ([n n] [Pn-1 x] [Pn-2 1])
    (case n
      [(0) Pn-2]
      [(1) Pn-1]
      [else (compute (- n 1)
                     (/ (- (* (- (* 2 n) 1) x Pn-1)
                           (* (- n 1) Pn-2)) n)
                     Pn-1)])))

(define (LegendreP′ n x)
  (* (/ n (- (* x x) 1))
     (- (* x (LegendreP n x))
        (LegendreP (- n 1) x))))
