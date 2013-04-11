(defn exp [n k]
  (cond
    (zero? (mod k 2)) (recur (* n n) (/ k 2))
    (zero? (mod k 3)) (recur (* n n n) (/ k 3))
    :else (reduce * (repeat k n))))
