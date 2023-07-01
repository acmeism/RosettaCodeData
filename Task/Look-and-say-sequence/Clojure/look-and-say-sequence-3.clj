(defn look-and-say
  [n]
  (->> (re-seq #"(.)\1*" n)
       (mapcat (comp (juxt count first) first))
       (apply str)))

(take 12 (iterate look-and-say "1"))
