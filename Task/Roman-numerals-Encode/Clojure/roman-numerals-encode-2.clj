(def roman-map
  (sorted-map
    1    "I", 4    "IV", 5   "V", 9   "IX",
    10   "X", 40   "XL", 50  "L", 90  "XC",
    100  "C", 400  "CD", 500 "D", 900 "CM"
    1000 "M"))

(defn int->roman [n]
  {:pre (integer? n)}
  (loop [res (StringBuilder.), n n]
    (if-let [v (roman-map n)]
      (str (.append res v))
      (let [[k v] (->> roman-map keys (filter #(> n %)) last (find roman-map))]
        (recur (.append res v) (- n k))))))

(int->roman 1999)
; "MCMXCIX"
