(use '[flatland.useful.seq :only (partition-between)])

(defn nonconsecutive? [[x y]]
  (not= (inc x) y))

(defn string-ranges [coll]
  (let [left (first coll)
        size (count coll)]
    (cond
      (> size 2) (str left "-" (last coll))
      (= size 2) (str left "," (last coll))
      :else (str left))))

(defn format-with-ranges [coll]
  (println (clojure.string/join ","
    (map string-ranges (partition-between nonconsecutive? coll)))))
