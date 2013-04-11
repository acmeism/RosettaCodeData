(defn factorial [x]
  (loop [x x
         acc 1]
    (if (< x 2)
        acc
        (recur (dec x) (* acc x)))))
