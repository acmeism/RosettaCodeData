(defn emirp? [v]
  (let [a (biginteger v)
        b (biginteger (clojure.string/reverse (str v)))]
    (and (not= a b)
         (.isProbablePrime a 16)
         (.isProbablePrime b 16))))

; Generate the output
(println "first20:    " (clojure.string/join " " (take 20 (filter emirp? (iterate inc 0)))))
(println "7700-8000:  " (clojure.string/join " " (filter emirp? (range 7700 8000))))
(println "10,000:     " (nth (filter emirp? (iterate inc 0)) 9999))
