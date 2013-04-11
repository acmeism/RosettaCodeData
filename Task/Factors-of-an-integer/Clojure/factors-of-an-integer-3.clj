(defn factors [n]
  (into (sorted-set)
    (reduce concat
      (for [x (range 1 (inc (sqrt n))) :when (zero? (rem n x))]
        [x (/ n x)]))))
