(defn dot-product [& matrix]
  {:pre [(apply == (map count matrix))]}
  (apply + (apply map * matrix)))

(defn dot-product2 [x y]
 (->> (interleave x y)
      (partition 2 2)
      (map #(apply * %))
      (reduce +)))

(defn dot-product3
  "Dot product of vectors. Tested on version 1.8.0."
  [v1 v2]
  {:pre [(= (count v1) (count v2))]}
  (reduce + (map * v1 v2)))

;Example Usage
(println (dot-product [1 3 -5] [4 -2 -1]))
(println (dot-product2 [1 3 -5] [4 -2 -1]))
(println (dot-product3 [1 3 -5] [4 -2 -1]))
