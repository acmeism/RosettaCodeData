(defn permutations [a-set]
  (cond (empty? a-set) '(())
        (empty? (rest a-set)) (list (apply list a-set))
        :else (for [x a-set y (permutations (remove #{x} a-set))]
                (cons x y))))
