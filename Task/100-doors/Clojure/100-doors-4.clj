(defn doors []
	(reduce (fn [doors idx] (assoc doors idx true))
	        (into [] (repeat 100 false))
	        (map #(dec (* % %)) (range 1 11))))

(defn open-doors [] (for [[d n] (map vector (doors) (iterate inc 1)) :when d] n))

(defn print-open-doors []
  (println
    "Open doors after 100 passes:"
    (apply str (interpose ", " (open-doors)))))
