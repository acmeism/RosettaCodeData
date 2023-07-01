(defn sum-mults [n & mults]
  (let [pred (apply some-fn
               (map #(fn [x] (zero? (mod x %))) mults))]
    (->> (range n) (filter pred) (reduce +))))

(println (sum-mults 1000 3 5))
