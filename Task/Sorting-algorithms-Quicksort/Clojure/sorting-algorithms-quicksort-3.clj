(defn qsort [[pivot & xs]]
  (when pivot
    (let [smaller #(< % pivot)]
      (lazy-cat (qsort (filter smaller xs))
		[pivot]
		(qsort (remove smaller xs))))))
