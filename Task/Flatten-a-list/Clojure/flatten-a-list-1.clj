(defn flatten [coll]
  (lazy-seq
    (when-let [s  (seq coll)]
      (if (coll? (first s))
        (concat (flatten (first s)) (flatten (rest s)))
        (cons (first s) (flatten (rest s)))))))
