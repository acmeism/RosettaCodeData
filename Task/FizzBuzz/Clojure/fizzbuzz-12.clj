;;Using clojure maps
(defn fizzbuzz
  [n]
  (let [rule {3 "Fizz"
              5 "Buzz"}
        divs (->> rule
                  (map first)
                  sort
                  (filter (comp (partial = 0)
                                (partial rem n))))]
    (if (empty? divs)
      (str n)
      (->> divs
           (map rule)
           (apply str)))))

(defn allfizzbuzz
  [max]
  (map fizzbuzz (range 1 (inc max))))
