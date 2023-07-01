(defn nextrow [row]
  (vec (concat [1] (map #(apply + %) (partition 2 1 row)) [1] )))

(defn pascal [n]
  (assert (and (integer? n) (pos? n)))
  (let [triangle (take n (iterate nextrow [1]))]
    (doseq [row triangle]
      (println row))))
