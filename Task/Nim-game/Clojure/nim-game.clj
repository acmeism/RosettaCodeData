(loop [n 12]
  (print (format "%s remain, take how many?\n> " n)) (flush)
  (let [v (try (Long. (clojure.string/trim (read-line)))
               (catch Exception _ 0))]
    (if (#{1 2 3} v)
      (do (println (format "You took %s, leaving %s, computer takes %s..."
                           v (- n v) (- 4 v)))
          (if (= 4 n)
            (println "Computer wins. 😐")
            (recur (- n 4))))
      (do (println "Please enter 1, 2, or 3...")
          (recur n)))))
