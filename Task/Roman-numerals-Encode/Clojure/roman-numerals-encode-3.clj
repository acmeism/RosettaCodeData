(defn a2r [a]
  (let [rv '(1000 500 100 50 10 5 1)
        rm (zipmap rv "MDCLXVI")
        dv (->> rv (take-nth 2) next #(interleave % %))]
    (loop [a a rv rv dv dv r nil]
      (if (<= a 0)
        r
        (let [v (first rv)
              d (or (first dv) 0)
              l (- v d)]
          (cond
            (= a v) (str r (rm v))
            (= a l) (str r (rm d) (rm v))
            (and (> a v) (> a l)) (recur (- a v) rv dv (str r (rm v)))
            (and (< a v) (< a l)) (recur a (rest rv) (rest dv) r)
            :else (recur (- a l) (rest rv) (rest dv) (str r (rm d) (rm v)))))))))
