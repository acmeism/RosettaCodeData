(defn sparkline [nums]
  (let [sparks   "▁▂▃▄▅▆▇█"
        high     (apply max nums)
        low      (apply min nums)
        spread   (- high low)
        quantize #(Math/round (* 7.0 (/ (- % low) spread)))]
        (apply str (map #(nth sparks (quantize %)) nums))))

(defn spark [line]
  (if line
    (let [nums (read-string (str "[" line "]"))]
      (println (sparkline nums))
      (recur (read-line)))))

(spark (read-line))
