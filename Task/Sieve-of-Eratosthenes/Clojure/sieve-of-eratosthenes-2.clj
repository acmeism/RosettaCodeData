(defn primes
  "Computes all prime numbers up to a given number using sieve of Eratosthenes"
  [n]
  (loop [cs (range 2 n) ; candidates
         ps [2]]             ; results
    (let [lp  (last ps)
          ncs (-> (range lp n lp) set (remove cs))]
      (if (> lp (Math/sqrt n))
        (concat ps ncs)
        (recur ncs (concat ps [(first ncs)]))))))
