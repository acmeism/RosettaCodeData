(defn print-cchanges [s]
  (println (clojure.string/join ", " (map first (re-seq #"(.)\1*" s)))))

(print-cchanges "gHHH5YY++///\\")
