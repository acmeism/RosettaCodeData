(defn mean [sq]
  (if (empty? sq)
      0
      (/ (reduce + sq) (count sq))))
