(defn perfect? [n]
  (->> (for [i (range 1 n)] :when (zero? (rem n i))] i)
       (reduce +)
       (= n)))
