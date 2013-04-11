(defn primes [max-prime]
  (let [new-sieve (fn []
          (let [v (reduce conj (vector-of :boolean) (range (inc max-prime)))]
            (assoc (assoc v 0 false) 1 false))),

        sieve (fn [S]
          (loop [s S, n 2]
            (let [n**2 (* n n)]
              (if (<= n**2 max-prime)
                (recur (if (s n)
                           (reduce #(assoc %1 %2 false) s (range n**2 (inc max-prime) n))
                           s)
                       (inc n))
                s)))),

        bitset-contents (fn [S]
          (map second (filter first (map vector S (range (count S))))))]

    (bitset-contents (sieve (new-sieve)))))
