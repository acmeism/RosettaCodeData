  (defn n-queens [n]
    (let[children #(map (partial conj %) (range n))
         no-conflict? (fn [x] (or (empty? x)
                                  (every? #(apply distinct? (map-indexed % x))
                                          [+ - (fn[_ v] v)])))]
      (filter (every-pred no-conflict? #(= n (count %)))
              (tree-seq (every-pred #(> n (count %))
                                    no-conflict?)
                        children []))))
