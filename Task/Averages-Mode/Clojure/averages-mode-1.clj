(defn modes [coll]
  (let [distrib (frequencies coll)
        [value freq] [first second] ; name the key/value pairs in the distrib (map) entries
        sorted (sort-by (comp - freq) distrib)
        maxfq (freq (first sorted))]
    (map value (take-while #(= maxfq (freq %)) sorted))))
