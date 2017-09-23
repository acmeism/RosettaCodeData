(declare prime?)

(def primes (filter prime? (range)))

(defn prime? [x]
  (or (= 2 x)
      (and (integer? x)
           (< 1 x)
           (not-any? (partial divides? x)
                     (take-while (partial > (math/sqrt x)) primes)))))
