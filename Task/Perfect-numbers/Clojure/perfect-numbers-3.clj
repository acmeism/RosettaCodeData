(defn perfect? [n]
	(= (reduce + (filter #(zero? (rem n %)) (range 1 n))) n))
