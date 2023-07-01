(defn valid-date? [[y m d]]
  (and (<= 1 m 12)
       (<= 1 d 31)))

(defn date-str [[y m d]]
  (format "%4d-%02d-%02d" y m d))

(defn yr->date [y]
  (let [[_ m d] (re-find #"(..)(..)" (apply str (reverse (str y))))]
    [y (Long. m) (Long. d)]))

(defn palindrome-dates [start-yr n]
  (->> (iterate inc start-yr)
       (map yr->date)
       (filter valid-date?)
       (map date-str)
       (take n)))
