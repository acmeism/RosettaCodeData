(defn proper-divisors [n]
  (if (< n 4)
    [1]
    (->> (range 2 (inc (quot n 2)))
         (filter #(zero? (rem n %)))
         (cons 1))))

(defn perfect? [n]
  (= (reduce + (proper-divisors n)) n))
