(defn vfringe-seq [v] (fringe-seq vector? #(remove nil? (rest %)) first v))
(println (vfringe-seq [10 1 2])) ; (1 2)
(println (vfringe-seq [10 [1 nil nil] [20 2 nil]])) ; (1 2)
