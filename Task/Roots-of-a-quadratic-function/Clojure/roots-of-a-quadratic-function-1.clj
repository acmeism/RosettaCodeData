; v1.1; number of solutions
(defn quad_sol [a b c]
  (def d (- (* b b) (* 4 a c)) )
  (if (< d 0) 0
    (if (> d 0) 2 1)) )
