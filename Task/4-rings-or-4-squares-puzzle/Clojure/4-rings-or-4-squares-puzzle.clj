(use '[clojure.math.combinatorics]

(defn rings [r & {:keys [unique] :or {unique true}}]
    (if unique
      (apply concat (map permutations (combinations r 7)))
      (selections r 7)))

(defn four-rings [low high & {:keys [unique] :or {unique true}}]
  (for [[a b c d e f g] (rings (range low (inc high)) :unique unique)
    :when (= (+ a b) (+ b c d) (+ d e f) (+ f g))] [a b c d e f g]))
