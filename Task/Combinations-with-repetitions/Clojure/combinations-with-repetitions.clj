(defn combinations [coll k]
  (when-let [[x & xs] coll]
    (if (= k 1)
      (map list coll)
      (concat (map (partial cons x) (combinations coll (dec k)))
              (combinations xs k)))))
