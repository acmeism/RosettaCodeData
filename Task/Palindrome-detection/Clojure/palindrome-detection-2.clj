(defn palindrome? [s]
  (loop [i 0
         j (dec (. s length))]
    (cond (>= i j) true
          (= (get s i) (get s j))
            (recur (inc i) (dec j))
          :else false)))
