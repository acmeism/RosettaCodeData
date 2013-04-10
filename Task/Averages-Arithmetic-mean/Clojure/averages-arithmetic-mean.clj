(defn mean [sq]
  (let [length (count sq)]
    (if (zero? length)
      0
      (/ (reduce + sq) length)))
)
