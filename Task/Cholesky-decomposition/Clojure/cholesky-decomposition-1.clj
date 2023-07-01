(defn cholesky
  [matrix]
  (let [n (count matrix)
        A (to-array-2d matrix)
        L (make-array Double/TYPE n n)]
    (doseq [i (range n) j (range (inc i))]
      (let [s (reduce + (for [k (range j)] (* (aget L i k) (aget L j k))))]
        (aset L i j (if (= i j)
                      (Math/sqrt (- (aget A i i) s))
                      (* (/ 1.0 (aget L j j)) (- (aget A i j) s))))))
    (vec (map vec L))))
