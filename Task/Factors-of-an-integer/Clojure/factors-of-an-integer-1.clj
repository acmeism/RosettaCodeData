(defn factors [n]
	(filter #(zero? (rem n %)) (range 1 (inc n))))

(print (factors 45))
