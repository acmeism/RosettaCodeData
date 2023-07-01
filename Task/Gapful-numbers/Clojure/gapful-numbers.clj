(defn first-digit [n] (Integer/parseInt (subs (str n) 0 1)))

(defn last-digit [n] (mod n 10))

(defn bookend-number [n] (+ (* 10 (first-digit n)) (last-digit n)))

(defn is-gapful? [n] (and (>= n 100) (zero? (mod n (bookend-number n)))))

(defn gapful-from [n] (filter is-gapful? (iterate inc n)))

(defn gapful [] (gapful-from 1))

(defn gapfuls-in-range [start size] (take size (gapful-from start)))

(defn report-range [[start size]]
  (doall (map println
    [(format "First %d gapful numbers >= %d:" size start)
     (gapfuls-in-range start size)
     ""])))

(doall (map report-range [ [1 30] [1000000 15] [1000000000 10] ]))
