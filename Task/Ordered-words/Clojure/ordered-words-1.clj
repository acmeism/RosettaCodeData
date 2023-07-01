(defn is-sorted? [coll]
  (not-any? pos? (map compare coll (next coll))))

(defn take-while-eqcount [coll]
  (let [n (count (first coll))]
    (take-while #(== n (count %)) coll)))

(with-open [rdr (clojure.java.io/reader "unixdict.txt")]
  (->> rdr
       line-seq
       (filter is-sorted?)
       (sort-by count >)
       take-while-eqcount
       (clojure.string/join ", ")
       println))
