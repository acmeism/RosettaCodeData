(defn balanced? [s]
  (empty?
    (reduce
      (fn [stack first]
        (case first
          \[ (conj stack \[)
          \] (if (seq stack)
               (pop stack)
               (reduced [:UNDERFLOW]))))
      '()
      s)))
