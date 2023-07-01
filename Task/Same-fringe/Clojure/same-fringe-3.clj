(defn seq= [s1 s2]
  (cond
    (and (empty? s1) (empty? s2)) true
    (not= (empty? s1) (empty? s2)) false
    (= (first s1) (first s2)) (recur (rest s1) (rest s2))
    :else false))
