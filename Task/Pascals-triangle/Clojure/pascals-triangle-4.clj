(def pascal
  (iterate #(concat [1]
                    (map + % (rest %))
                    [1])
           [1]))
