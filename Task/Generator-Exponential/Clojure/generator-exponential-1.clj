(defn powers [m] (for [n (iterate inc 1)] (reduce * (repeat m n)))))
(def squares (powers 2))
(take 5 squares) ; => (1 4 9 16 25)
