(doseq [n (range 1 11)]
  (print n)
  (if (zero? (rem n 5))
      (println)
      (print ", ")))
