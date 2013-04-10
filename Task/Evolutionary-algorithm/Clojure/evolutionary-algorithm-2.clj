(defn fitness [s] (count (filter true? (map = s target))))
(defn perfectly-fit? [s] (= (fitness s) tsize))

(defn randc [] (rand-nth alphabet))
(defn mutate [s] (map #(if (< (rand) p) (randc) %) s))
