(defn primes-to
  "Computes lazy sequence of prime numbers up to a given number using sieve of Eratosthenes"
  [n]
  (letfn [(nxtprm [cs] ; current candidates
            (let [p (first cs)]
              (if (> p (Math/sqrt n)) cs
                (cons p (lazy-seq (nxtprm (-> (range (* p p) (inc n) p)
                                              set (remove cs) rest)))))))]
    (nxtprm (range 2 (inc n)))))
