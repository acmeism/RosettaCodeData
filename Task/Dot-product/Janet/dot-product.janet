(defn dot-product
  "Calculates the dot product of two vectors."
  [vec-a vec-b]
  (assert (= (length vec-a) (length vec-b)) "Vector sizes must match")
  (sum (map * vec-a vec-b)))

(print (dot-product [1 3 -5] [4 -2 -1]))
