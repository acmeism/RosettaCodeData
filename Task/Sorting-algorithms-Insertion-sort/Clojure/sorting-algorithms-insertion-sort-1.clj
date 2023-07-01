(defn insertion-sort [coll]
   (reduce (fn [result input]
             (let [[less more] (split-with #(< % input) result)]
               (concat less [input] more)))
           []
           coll))
