(defn open-doors []
  (->> (for [step (range 1 101), occ (range step 101 step)] occ)
       frequencies
       (filter (comp odd? val))
       keys
       sort))

(defn print-open-doors []
  (println
    "Open doors after 100 passes:"
    (apply str (interpose ", " (open-doors)))))
