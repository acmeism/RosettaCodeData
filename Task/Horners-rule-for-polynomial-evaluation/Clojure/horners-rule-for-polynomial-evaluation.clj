(defn horner [coeffs x]
  (reduce #(-> %1 (* x) (+ %2)) (reverse coeffs)))

(println (horner [-19 7 -4 6] 3))
