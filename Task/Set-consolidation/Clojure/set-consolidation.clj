(defn consolidate-linked-sets [sets]
  (apply clojure.set/union sets))

(defn linked? [s1 s2]
  (not (empty? (clojure.set/intersection s1 s2))))

(defn consolidate [& sets]
  (loop [seeds sets
         sets  sets]
    (if (empty? seeds)
      sets
      (let [s0     (first seeds)
            linked (filter #(linked? s0 %) sets)
            remove-used (fn [sets used]
                          (remove #(contains? (set used) %) sets))]
        (recur (remove-used (rest seeds) linked)
               (conj (remove-used sets linked)
                     (consolidate-linked-sets linked)))))))
