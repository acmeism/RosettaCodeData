(defn factors [n]
  (into (sorted-set)
    (mapcat (fn [x] [x (/ n x)])
      (filter #(zero? (rem n %)) (range 1 (inc (Math/sqrt n)))) )))
