(defn sum-mults [n & mults]
  (transduce (filter (fn [x] (some (fn [mult] (zero? (mod x mult))) mults)))
             + (range n)))

(println (sum-mults 1000 3 5))
