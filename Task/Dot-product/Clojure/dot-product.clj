(defn dot-product [& matrix]
  {:pre [(apply == (map count matrix))]}
  (apply + (apply map * matrix)))

(defn dot-product2 [x y]
 (->> (interleave x y)
      (partition 2 2)
      (map #(apply * %))
      (reduce +)))


;Example Usage
(println (dot-product [1 3 -5] [4 -2 -1]))
(println (dot-product2 [1 3 -5] [4 -2 -1]))
