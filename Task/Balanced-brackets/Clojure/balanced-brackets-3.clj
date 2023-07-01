(defn balanced? [s]
  (let [opens-closes (->> s
                          (map {\[ 1, \] -1})
                          (reductions + 0))]
    (and (not-any? neg? opens-closes) (zero? (last opens-closes)))))
