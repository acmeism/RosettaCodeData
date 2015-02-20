(defn powerset [coll]
  (reduce (fn [a x]
            (->> a
                 (map #(set (concat #{x} %)))
                 (concat a)
                 set))
          #{#{}} coll))

(powerset #{1 2 3})
