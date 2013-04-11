(defn flatten [x]
  (filter (complement sequential?)
          (rest (tree-seq sequential? seq x))))
