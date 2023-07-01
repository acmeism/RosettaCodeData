(defn parse-line [s]
  (let [[date & data-toks] (str/split s #"\s+")
        data-fields (map read-string data-toks)
        valid-date? (fn [s] (re-find #"\d{4}-\d{2}-\d{2}" s))
        valid-line? (and (valid-date? date)
                         (= 48 (count data-toks))
                         (every? number? data-fields))
        readings    (for [[v flag] (partition 2 data-fields)]
                      {:val v :flag flag})]
    (when (not valid-line?)
      (println "Malformed Line: " s))
    {:date date
     :no-missing-readings? (and (= 48 (count data-toks))
                                (every? pos? (map :flag readings)))}))

(defn analyze-file [path]
  (reduce (fn [m line]
            (let [{:keys [all-dates dupl-dates n-full-recs invalid-lines]} m
                  this-date (:date line)
                  dupl? (contains? all-dates this-date)
                  full? (:no-missing-readings? line)]
              (cond-> m
                dupl? (update-in [:dupl-dates]  conj this-date)
                full? (update-in [:n-full-recs] inc)
                true  (update-in [:all-dates]   conj this-date))))
          {:dupl-dates #{} :all-dates #{} :n-full-recs 0}
          (->> (slurp path)
               clojure.string/split-lines
               (map parse-line))))

(defn report-summary [path]
  (let [m (analyze-file path)]
    (println (format "%d unique dates" (count (:all-dates m))))
    (println (format "%d duplicated dates [%s]"
                     (count (:dupl-dates m))
                     (clojure.string/join " " (sort (:dupl-dates m)))))
    (println (format "%d lines with no missing data" (:n-full-recs m)))))
