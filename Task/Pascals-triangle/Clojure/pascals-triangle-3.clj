(def pascal
  (iterate
    (fn [prev-row]
      (->>
        (concat [[(first prev-row)]] (partition 2 1 prev-row) [[(last prev-row)]])
        (map (partial apply +) ,,,)))
     [1]))
