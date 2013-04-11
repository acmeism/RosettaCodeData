(defn qsort [[pvt & rs]]
  (if pvt
    `(~@(qsort (filter #(<  % pvt) rs))
      ~pvt
      ~@(qsort (filter #(>= % pvt) rs)))))
