(defn primes-to
  "Computes lazy sequence of prime numbers up to a given number using sieve of Eratosthenes"
  [max-prime]
  (let [sieve (fn [s n]
                (if (<= (* n n) max-prime)
                  (recur (if (s n)
                           (reduce #(assoc %1 %2 false) s (range (* n n) (inc max-prime) n))
                           s)
                         (inc n))
                  s))]
    (->> (-> (reduce conj (vector-of :boolean) (map #(= % %) (range (inc max-prime))))
             (assoc 0 false)
             (assoc 1 false)
             (sieve 2))
         (map-indexed #(vector %2 %1)) (filter first) (map second))))
