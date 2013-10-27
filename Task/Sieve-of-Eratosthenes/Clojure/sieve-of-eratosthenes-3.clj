(defn primes
  "Computes all prime numbers up to a given number using sieve of Eratosthenes"
  [number]
  (loop [candidates (range 2 number)
         primes [2]]
    (let [toremove (range (last primes) number (last primes))]
      (let [newcandidates (remove (set toremove) candidates)]
        (if (> (last primes) (math/sqrt number))
          (concat primes newcandidates)
          (recur newcandidates
                 (concat primes [(first newcandidates)])))))))
