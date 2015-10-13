(println (reduce + (map #(Integer/parseInt %) (clojure.string/split (read-line) #"\s") )))

3 4
=>7
