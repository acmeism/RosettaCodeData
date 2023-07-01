(defn rump [a b]
  (+ (* (rationalize 333.75) (expt b 6))
      (* (expt a 2)
          (- (* 11 (expt a 2) (expt b 2)) (expt b 6) (* 121 (expt b 4)) 2))
      (* (rationalize 5.5) (expt b 8))
      (/ a (* 2 b))))
; Using BigInt numeric literal style to avoid integer overflow
(double (rump 77617 33096N))
