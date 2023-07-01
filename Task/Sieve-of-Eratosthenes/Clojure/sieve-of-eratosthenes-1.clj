(defn primes< [n]
   (remove (set (mapcat #(range (* % %) n %)
                        (range 2 (Math/sqrt n))))
           (range 2 n)))
