(let [n 1e10]
  (loop [i 1
         out (- (Math/log n))]
    (if (<= i n)
      (recur (inc i) (+ out (/ 1.0 i)))
      out)))
