(defn squeeze [s c]
  (let [spans (partition-by #(= c %) s)
        span-out (fn [span]
                   (if (= c (first span))
                     (str c)
                     (apply str span)))]
    (apply str (map span-out spans))))

(defn test-squeeze [s c]
  (let [out (squeeze s c)]
    (println (format "Input:   <<<%s>>> (len %d)\n" s (count s))
             (format "becomes: <<<%s>>> (len %d)" out (count out)))))
