(def bottom [ [0 1 0], [11 0 0], [0 1 1], [4 0 0], [0 0 1] ])

(defn plus  [v1 v2] (vec (map + v1 v2)))
(defn minus [v1 v2] (vec (map - v1 v2)))
(defn scale [n v]   (vec (map #(* n %) v )))

(defn above [row] (map #(apply plus %) (partition 2 1 row)))

(def rows (reverse (take 5 (iterate above bottom))))
