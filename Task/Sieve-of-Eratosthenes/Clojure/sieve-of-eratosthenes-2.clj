(defn primes< [n]
   (remove (into #{}
                 (mapcat #(range (* % %) n %)
                         (range 2 (Math/sqrt n))))
           (range 2 n)))
