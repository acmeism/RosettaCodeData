(defn collapse [s]
  (let [runs (partition-by identity s)]
    (apply str (map first runs))))

(defn run-test [s]
  (let [out (collapse s)]
    (str (format "Input: <<<%s>>> (len %d)\n" s (count s))
         (format "becomes: <<<%s>>> (len %d)\n" out (count out)))))
