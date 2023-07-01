(ns example
  (:gen-class))

; Lazy Sequence of primes (starting with number 2)
(def primes (iterate #(.nextProbablePrime %) (biginteger 2)))

(defn primorial-prime? [v]
  " Test if value is a primorial prime "
  (let [a (biginteger (inc v))
        b (biginteger (dec v))]
    (or (.isProbablePrime a 16)
      (.isProbablePrime b 16))))

; Generate indexes for first 20 primorial primes
(println (take 20 (keep-indexed                                 ; take the first 20
                          #(if (primorial-prime? %2) (inc %1))  ; filters out non-primorials, passing on the index + 1 (since sequence begins with 1 (not 0)
                          (reductions *' primes))))             ; computes the lazy sequence of product of 1 prime, 2 primes, 3 primes, etc.
