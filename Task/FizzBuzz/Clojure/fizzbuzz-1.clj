(doseq [x (range 1 101)] (println x (str (when (zero? (mod x 3)) "fizz") (when (zero? (mod x 5)) "buzz"))))
