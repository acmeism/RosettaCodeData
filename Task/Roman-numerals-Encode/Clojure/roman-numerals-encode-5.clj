(def roman-map
  (sorted-map-by >
                 1    "I", 4    "IV", 5   "V", 9   "IX",
                 10   "X", 40   "XL", 50  "L", 90  "XC",
                 100  "C", 400  "CD", 500 "D", 900 "CM"
                 1000 "M"))

(defn a2r
  ([r]
   (reduce str (a2r r (keys roman-map))))
  ([r n]
   (when-not (empty? n)
     (let [e (first n)
           v (- r e)
           roman (roman-map e)]
       (cond
         (< v 0) (a2r r (rest n))
         (= v 0) (cons roman [])
         (>= v e) (cons roman (a2r v n))
         (< v e) (cons roman (a2r v (rest n))))))))
