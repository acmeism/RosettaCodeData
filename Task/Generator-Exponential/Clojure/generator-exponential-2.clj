(defn squares-not-cubes
  ([] (squares-not-cubes (powers 2) (powers 3)))
  ([squares cubes]
    (loop [[p2first & p2rest :as p2s] squares, [p3first & p3rest :as p3s] cubes]
      (cond
        (= p2first p3first) (recur p2rest p3rest)
        (> p2first p3first) (recur p2s p3rest)
        :else (cons p2first (lazy-seq (squares-not-cubes p2rest p3s)))))))

(->> (squares-not-cubes) (drop 20) (take 10))
; => (529 576 625 676 784 841 900 961 1024 1089)
