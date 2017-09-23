(defn rms [xs]
  (Math/sqrt (/ (reduce + (map #(* % %) xs))
	   (count xs))))

(println (rms (range 1 11)))
