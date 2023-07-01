(defn counting-numbers
 ([] (counting-numbers 1))
 ([n] (lazy-seq (cons n (counting-numbers (inc n))))))
(defn divisors [n] (filter #(zero? (mod n %)) (range 1 (inc n))))
(defn prime? [n] (= (divisors n) (list 1 n)))
(defn pernicious? [n]
  (prime? (count (filter #(= % \1) (Integer/toString n 2)))))
(println (take 25 (filter pernicious? (counting-numbers))))
(println (filter pernicious? (range 888888877  888888889)))
