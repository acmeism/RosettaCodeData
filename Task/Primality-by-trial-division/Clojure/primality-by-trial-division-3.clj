(declare prime?)

(def primes (filter prime? (range)))

(defn prime? [x]
  (and (integer? x)
       (< 1 x)
       (not-any? (partial divides? x)
                 (take-while (partial >= (Math/sqrt x)) primes))))
