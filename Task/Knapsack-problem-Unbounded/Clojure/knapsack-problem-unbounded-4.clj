(defn all-best-by-value [ks]
  (let [b (best-by-value ks)]
    (filter #(= (:value b) (:value %)) ks)))

(defn print-knapsacks [ks]
  (doseq [k ks]
    (print-knapsack k)
    (println)))
