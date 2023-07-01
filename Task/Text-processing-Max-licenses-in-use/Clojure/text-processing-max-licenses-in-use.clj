(defn delta [entry]
  (case (second (re-find #"\ (.*)\ @" entry))
    "IN " -1
    "OUT" 1
    (throw (Exception. (str "Invalid entry:" entry)))))

(defn t [entry]
  (second (re-find #"@\ (.*)\ f" entry)))

(let [entries (clojure.string/split (slurp "mlijobs.txt") #"\n")
      in-use (reductions + (map delta entries))
      m (apply max in-use)
      times (map #(nth (map t entries) %)
                 (keep-indexed #(when (= m %2) %1) in-use))]
  (println "Maximum simultaneous license use is" m "at the following times:")
  (map println times))
