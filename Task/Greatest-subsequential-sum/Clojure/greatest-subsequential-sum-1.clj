(defn max-subseq-sum [coll]
  (->> (take-while seq (iterate rest coll)) ; tails
       (mapcat #(reductions conj [] %)) ; inits
       (apply max-key #(reduce + %)))) ; max sum
