(defn combinations
  "Generate the combinations of n elements from a list of [0..m)"
  [m n]
  (let [xs (range m)]
    (loop [i (int 0) res #{#{}}]
      (if (== i n)
        res
        (recur (+ 1 i)
               (set (for [x xs r res
                          :when (not-any? #{x} r)]
                      (conj r x))))))))
