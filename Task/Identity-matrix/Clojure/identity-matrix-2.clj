(defn identity-matrix [n]
  (let [row (conj (repeat (dec n) 0) 1)]
    (vec
      (for [i (range 1 (inc n))]
        (vec
          (reduce conj (drop i row ) (take i row)))))))
