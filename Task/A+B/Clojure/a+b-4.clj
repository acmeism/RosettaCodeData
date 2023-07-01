(let [ints (map #(Integer/parseInt %) (clojure.string/split (read-line) #"\s") )]
  (println (reduce + ints)))
3 4
=>7
