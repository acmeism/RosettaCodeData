(defn normalize [r]
  (let [[n1 n2] r]
    [(min n1 n2) (max n1 n2)]))

(defn touch? [r1 r2]
  (let [[lo1 hi1] (normalize r1)
        [lo2 hi2] (normalize r2)]
    (or (<= lo2 lo1 hi2)
        (<= lo2 hi1 hi2))))

(defn consolidate-touching-ranges [rs]
  (let [lows  (map #(apply min %) rs)
        highs (map #(apply max %) rs)]
    [ (apply min lows) (apply max highs) ]))

(defn consolidate-ranges [rs]
  (loop [res []
         rs  rs]
    (if (empty? rs)
      res
      (let [r0 (first rs)
            touching (filter #(touch? r0 %) rs)
            remove-used (fn [rs used]
                          (remove #(contains? (set used) %) rs))]
        (recur (conj res (consolidate-touching-ranges touching))
               (remove-used (rest rs) touching))))))
