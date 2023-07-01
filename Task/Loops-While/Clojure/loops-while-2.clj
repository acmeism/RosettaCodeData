(loop [i 1024]
  (when (pos? i)
    (println i)
    (recur (quot i 2))))


(doseq [i (take-while pos? (iterate #(quot % 2) 1024))]
  (println i))
