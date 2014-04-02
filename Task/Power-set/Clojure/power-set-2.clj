(defn powerset
  [coll]
  (reduce (fn [a x]
            (set (concat a (map #(set (concat #{x} %)) a))))
          #{#{}} coll))

(powerset #{1 2 3})
