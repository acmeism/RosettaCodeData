(defn transpose [xs]
  (loop [transposed [], remaining xs]
    (if (empty? remaining)
      transposed
      (recur
        (conj transposed (map #(first %) remaining))
        (filter #(not-empty %) (map #(rest %) remaining)))) ))

(defn bead-sort [xs]
  (map #(reduce + %)
    (transpose
      (transpose (map #(replicate % 1) xs)))))

(println (bead-sort [5 2 4 1 3 3 9]))
