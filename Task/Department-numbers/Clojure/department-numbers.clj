(let [n (range 1 8)]
  (for [police n
        sanitation n
        fire n
        :when (distinct? police sanitation fire)
        :when (even? police)
        :when (= 12 (+ police sanitation fire))]
    (println police sanitation fire)))
