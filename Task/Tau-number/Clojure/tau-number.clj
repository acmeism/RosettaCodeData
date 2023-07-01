(require '[clojure.string :refer [join]])
(require '[clojure.pprint :refer [cl-format]])

(defn divisors [n] (filter #(zero? (rem n %)) (range 1 (inc n))))

(defn display-results [label per-line width nums]
  (doall (map println (cons (str "\n" label ":") (list
    (join "\n" (map #(join " " %)
      (partition-all per-line (map #(cl-format nil "~v:d" width %) nums)))))))))

(display-results "Tau function - first 100" 20 3
                 (take 100 (map (comp count divisors) (drop 1 (range)))))

(display-results "Tau numbers – first 100" 10 5
                 (take 100 (filter #(zero? (rem % (count (divisors %)))) (drop 1 (range)))))

(display-results "Divisor sums – first 100" 20 4
                 (take 100 (map #(reduce + (divisors %)) (drop 1 (range)))))

(display-results "Divisor products – first 100" 5 16
                 (take 100 (map #(reduce * (divisors %)) (drop 1 (range)))))
