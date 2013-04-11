(defn perfect? [n]
  (= n (reduce + (for [i (range 1 n) :when (= 0 (mod n i))] i))))
