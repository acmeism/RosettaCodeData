(defn qsort3 [[pvt :as coll]]
  (when pvt
    (let [{left -1 mid 0 right 1} (group-by #(compare % pvt) coll)]
      (lazy-cat (qsort3 left) mid (qsort3 right)))))
