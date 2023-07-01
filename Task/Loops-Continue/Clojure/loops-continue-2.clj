(loop [xs (range 1 11)]
  (when-let [x (first xs)]
    (print x)
    (if (zero? (rem x 5))
        (println)
        (print ", "))
    (recur (rest xs))))
