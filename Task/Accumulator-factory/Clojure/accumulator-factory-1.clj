(defn accum [n]
  (let [acc (atom n)]
    (fn [m] (swap! acc + m))))
