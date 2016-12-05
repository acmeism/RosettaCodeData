(defn primes-hashmap
  "Infinite sequence of primes using an incremental Sieve or Eratosthenes with a Hashmap"
  []
  (letfn [(nxtoddprm [c q bsprms cmpsts]
            (if (>= c q) ;; only ever equal
              (let [p2 (* (first bsprms) 2), nbps (next bsprms), nbp (first nbps)]
                (recur (+ c 2) (* nbp nbp) nbps (assoc cmpsts (+ q p2) p2)))
              (if (contains? cmpsts c)
                (recur (+ c 2) q bsprms
                       (let [adv (cmpsts c), ncmps (dissoc cmpsts c)]
                         (assoc ncmps
                                (loop [try (+ c adv)] ;; ensure map entry is unique
                                  (if (contains? ncmps try)
                                    (recur (+ try adv)) try)) adv)))
                (cons c (lazy-seq (nxtoddprm (+ c 2) q bsprms cmpsts))))))]
    (do (def baseoddprms (cons 3 (lazy-seq (nxtoddprm 5 9 baseoddprms {}))))
        (cons 2 (lazy-seq (nxtoddprm 3 9 baseoddprms {}))))))
