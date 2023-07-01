(defn divisible? [a b]
  (zero? (mod a b)))

(defn prime? [n]
  (and (> n 1) (not-any? (partial divisible? n) (range 2 n))))

(defn prime-factors
  ([n] (prime-factors n 2 '()))
  ([n candidate acc]
    (cond
      (<= n 1) (reverse acc)
      (zero? (rem n candidate)) (recur
                                  (/ n candidate)
                                  candidate
                                  (cons candidate acc))
      :else (recur n (inc candidate) acc))))

(defn sum-digits [n]
  (reduce + (map #(- (int %) (int \0)) (str n))))

(defn smith-number? [n]
  (and (not (prime? n))
       (= (sum-digits n)
          (sum-digits (clojure.string/join "" (prime-factors n))))))

(filter smith-number? (range 1 10000))
