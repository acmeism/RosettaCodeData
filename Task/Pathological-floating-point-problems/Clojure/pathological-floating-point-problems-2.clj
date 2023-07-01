(def e-ratio 106246577894593683/39085931702241241)
(defn bank [n m] (- (* n m) 1))
(double (reduce bank (- e-ratio 1) (range 1 26)))
