(defn best-by-value [ks]
  (reduce #(if (> (:value %1) (:value %2)) %1 %2) ks))

(defn print-knapsack[k]
  (let [ {val :value w :weight  v :volume} k
        {p :p i :i g :g} ^k]
    (println "Maximum value:" (float val))
    (println "Total weight: " (float w))
    (println "Total volume: " (float v))
    (println "Containing:   " p "Panacea," i "Ichor," g "Gold")))
