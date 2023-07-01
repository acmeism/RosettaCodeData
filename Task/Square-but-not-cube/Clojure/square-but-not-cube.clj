(def squares (map #(* % %) (drop 1 (range))))
(def square-cubes (map #(int (. Math pow % 6)) (drop 1 (range))))

(def squares-not-cubes (filter #(not (= % (first (drop-while (fn [n] (< n %)) square-cubes)))) squares))

(println "Squares but not cubes:")
(println (take 30 squares-not-cubes))
(println "Both squares and cubes:")
(println (take 15 square-cubes))
