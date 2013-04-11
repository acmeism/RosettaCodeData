(defn proper-divisors [n]
  (if (< n 4)
    '(1)
    (cons 1 (filter #(zero? (rem n %)) (range 2 (inc (quot n 2))))))
)
(defn perfect? [n]
  (== (reduce + (proper-divisors n)) n)
)
