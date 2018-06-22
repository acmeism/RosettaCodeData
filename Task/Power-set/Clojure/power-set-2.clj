(defn powerset [coll]
  (reduce (fn [a x]
            (into a (map #(conj % x)) a))
          #{#{}} coll))

(powerset #{1 2 3})
