(defn pyth-count [peri]
  (reduce (fn [[total prims] k] [(+ total k), (inc prims)]) [0 0]
    (for [m (range 2 (Math/sqrt (/ peri 2)))
          n (range (inc (mod m 2)) m 2) ; n<m, opposite polarity
          :let [p (* 2 m (+ m n))]      ; = a+b+c for this (m,n)
          :while (<= p peri)
          :when (= 1 (gcd m n))]
      (quot peri p))))
