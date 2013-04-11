(def prime-gen
     (let [primes (atom [])]
       (for [n (iterate inc 2)
             :when (not-any? #(zero? (rem n %))
                             (filter #(<= % (Math/sqrt n))
                                     @primes))]
         (do (swap! primes conj n)
             n))))
