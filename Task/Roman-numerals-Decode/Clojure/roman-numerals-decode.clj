(defn ro2ar [r]
  (->> (reverse r)
       (replace (zipmap "MDCLXVI" [1000 500 100 50 10 5 1]))
       (partition-by identity)
       (map (partial apply +))
       (reduce #(if (< %1 %2) (+ %1 %2) (- %1 %2)))))

;; alternative
(def numerals { \I 1, \V 5, \X 10, \L 50, \C 100, \D 500, \M 1000})
(defn from-roman [s]
  (->> s .toUpperCase
    (map numerals)
    (reduce (fn [[sum lastv] curr] [(+ sum curr (if (< lastv curr) (* -2 lastv) 0)) curr]) [0,0])
    first))
