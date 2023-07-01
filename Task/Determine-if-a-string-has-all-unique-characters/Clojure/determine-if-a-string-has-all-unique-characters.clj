(defn uniq-char-string [s]
  (let [len (count s)]
    (if (= len (count (set s)))
      (println (format "All %d chars unique in: '%s'" len s))
      (loop [prev-chars #{}
             idx   0
             chars (vec s)]
        (let [c (first chars)]
          (if (contains? prev-chars c)
            (println (format "'%s' (len: %d) has '%c' duplicated at idx: %d"
                             s len c idx))
            (recur (conj prev-chars c)
                   (inc idx)
                   (rest chars))))))))
