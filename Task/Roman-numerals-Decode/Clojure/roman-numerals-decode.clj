;; Incorporated some improvements from the alternative implementation below
(defn ro2ar [r]
  (->> (reverse (.toUpperCase r))
       (map {\M 1000 \D 500 \C 100 \L 50 \X 10 \V 5 \I 1})
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
