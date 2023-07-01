(defn indexed [ps] (map vector (iterate inc 0) ps))

(defn differentiate [ps]
  (drop 1 (for [[n a] (indexed ps)] (* n a))))

(defn integrate [ps]
  (cons 0 (for [[n a] (indexed ps)] (/ a (inc n)))))
