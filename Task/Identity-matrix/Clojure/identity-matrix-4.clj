(defn identity-matrix [n]
  (take n
    (partition n (dec n)
                         (cycle (conj (repeat (dec n) 0) 1)))))
