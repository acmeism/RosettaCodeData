(defn modes [coll]
  (->> coll frequencies (sort-by val >) (partition-by val) first (map key)))
