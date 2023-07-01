(defn mean [sq]
  (if (empty? sq)
      0
      (float (/ (reduce + sq) (count sq)))))
