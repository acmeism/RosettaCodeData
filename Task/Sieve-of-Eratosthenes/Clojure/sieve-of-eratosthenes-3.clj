(defn primes< [n]
   (if (< n 2) ()
     (cons 2 (remove (into #{}
                           (mapcat #(range (* % %) n %)
                                   (range 3 (Math/sqrt n) 2)))
                     (range 3 n 2)))))
