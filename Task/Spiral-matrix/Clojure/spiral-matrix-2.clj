(defn spiral-matrix [m n & [start]]
  (let [row (list (map #(+ start %) (range m)))]
    (if (= 1 n) row
      (concat row (map reverse
                       (apply map list
                              (spiral-matrix (dec n) m (+ start m))))))))

(defn spiral [n m] (spiral-matrix n m 1))
