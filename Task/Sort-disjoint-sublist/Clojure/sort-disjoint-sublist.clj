(defn disjoint-sort [coll idxs]
  (let [val-subset (keep-indexed #(when ((set idxs) %) %2) coll)
        replacements (zipmap (set idxs) (sort val-subset))]
    (apply assoc coll (flatten (seq replacements)))))
