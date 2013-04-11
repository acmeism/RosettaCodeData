(defn dot [v1 v2] (reduce + (map * v1 v2)))

(defn show-pyramid [x z]
  (doseq [row rows]
    (println (map #(dot [1 x z] %) row)))
