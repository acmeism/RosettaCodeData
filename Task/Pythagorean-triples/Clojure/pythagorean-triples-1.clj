(defn gcd [a b] (if (zero? b) a (recur b (mod a b))))

(defn pyth [peri]
  (for [m (range 2 (Math/sqrt (/ peri 2)))
        n (range (inc (mod m 2)) m 2) ; n<m, opposite polarity
        :let [p (* 2 m (+ m n))]      ; = a+b+c for this (m,n)
        :while (<= p peri)
        :when (= 1 (gcd m n))
        :let [m2 (* m m), n2 (* n n),
              [a b] (sort [(- m2 n2) (* 2 m n)]), c (+ m2 n2)]
        k (range 1 (inc (quot peri p)))]
    [(= k 1) (* k a) (* k b) (* k c)]))

(defn rcount [ts] ; (->> peri pyth rcount) produces [total, primitive] counts
  (reduce (fn [[total prims] t] [(inc total), (if (first t) (inc prims) prims)])
    [0 0]
    ts))
