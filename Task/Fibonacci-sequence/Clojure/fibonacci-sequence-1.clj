(defn fibs []
  (map first (iterate (fn [[a b]] [b (+ a b)]) [0 1])))
