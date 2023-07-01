(defn oid-vec [oid-str]
  (->> (clojure.string/split oid-str #"\.")
       (map #(Long. %))))

(defn oid-str [oid-vec]
  (clojure.string/join "." oid-vec))

;;
;; If vals differ before shorter vec ends,
;; use comparison of that "common header".
;; If common part matches, compare based on num elements.
;;
(defn oid-compare [a b]
  (let [min-len    (min (count a) (count b))
        common-cmp (compare (vec (take min-len a))
                            (vec (take min-len b)))]
    (if (zero? common-cmp)
      (compare (count a) (count b))
      common-cmp)))

(defn sort-oids [oid-strs]
  (->> (map  oid-vec oid-strs)
       (sort oid-compare)
       (map  oid-str)))
