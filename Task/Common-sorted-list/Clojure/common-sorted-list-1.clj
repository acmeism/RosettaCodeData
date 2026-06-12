(defn common-sorted [& colls]
  (into (sorted-set) cat colls))

(common-sorted [5 1 3 8 9 4 8 7] [3 5 9 8 4] [1 3 7 9])
;; => #{1 3 4 5 7 8 9}
