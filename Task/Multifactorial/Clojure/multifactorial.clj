(defn !! [m n]
  (->> (iterate #(- % m) n) (take-while pos?) (apply *)))

(doseq [m (range 1 6)]
  (prn m (map #(!! m %) (range 1 11))))
