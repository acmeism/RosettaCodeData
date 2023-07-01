(defn count-words [file n]
  (->> file
    slurp
    clojure.string/lower-case
    (re-seq #"\w+")
    frequencies
    (sort-by val >)
    (take n)))
