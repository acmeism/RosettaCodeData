(loop [generation 1, parent (repeatedly tsize randc)]
  (println generation, (apply str parent), (fitness parent))
  (if-not (perfectly-fit? parent)
    (let [children (repeatedly c #(mutate parent))
          fittest (apply max-key fitness parent children)]
      (recur (inc generation), fittest))))
