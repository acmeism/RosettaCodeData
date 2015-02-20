(defn primes [max-prime]
  (let [sieve (fn [s n]
                (if (<= (* n n) max-prime)
                  (recur (if (s n)
                           (reduce #(assoc %1 %2 false) s (range (* n n) (inc max-prime) n))
                           s)
                         (inc n))
                  s))]
    (-> (vector-of :boolean) ; form the return vector
        (reduce conj (range (inc max-prime)))
        (assoc 0 false)
        (assoc 1 false)
        (sieve 2)
        #(->> % count range (map vector %) (filter first) (map second)))))
