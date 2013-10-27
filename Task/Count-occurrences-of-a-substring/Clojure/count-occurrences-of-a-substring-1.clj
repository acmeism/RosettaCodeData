(defn count-substring [txt sub]
  (count (re-seq (re-pattern sub) txt)))
