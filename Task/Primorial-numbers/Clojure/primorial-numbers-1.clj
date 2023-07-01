(ns example
  (:gen-class))

; Generate Prime Numbers (Implementation from RosettaCode--link above)
(defn primes-hashmap
  "Infinite sequence of primes using an incremental Sieve or Eratosthenes with a Hashmap"
  []
  (letfn [(nxtoddprm [c q bsprms cmpsts]
            (if (>= c q) ;; only ever equal
              ; Update cmpsts with primes up to sqrt c
              (let [p2 (* (first bsprms) 2),
                    nbps (next bsprms),
                    nbp (first nbps)]
                (recur (+ c 2) (* nbp nbp) nbps (assoc cmpsts (+ q p2) p2)))

              (if (contains? cmpsts c)
                ; Not prime
                (recur (+ c 2) q bsprms
                       (let [adv (cmpsts c), ncmps (dissoc cmpsts c)]
                         (assoc ncmps
                           (loop [try (+ c adv)] ;; ensure map entry is unique
                             (if (contains? ncmps try)
                               (recur (+ try adv))
                               try))
                           adv)))
                ; prime
                (cons c (lazy-seq (nxtoddprm (+ c 2) q bsprms cmpsts))))))]
    (do (def baseoddprms (cons 3 (lazy-seq (nxtoddprm 5 9 baseoddprms {}))))
        (cons 2 (lazy-seq (nxtoddprm 3 9 baseoddprms {}))))))
		
;; Generate Primorial Numbers
(defn primorial [n]
  " Function produces the nth primorial number"
  (if (= n 0)
    1                                                           ; by definition
    (reduce *' (take n (primes-hashmap)))))                     ; multiply first n primes (retrieving primes from lazy-seq which generates primes as needed)
	
;; Show Results
(let [start (System/nanoTime)
      elapsed-secs (fn [] (/ (- (System/nanoTime) start) 1e9))]   ; System start time
  (doseq [i (concat (range 10) [1e2 1e3 1e4 1e5 1e6])
          :let [p (primorial i)]]                               ; Generate ith primorial number
    (if (< i 10)
      (println (format "primorial ( %7d ) = %10d" i (biginteger p)))         ; Output for first 10
      (println (format "primorial ( %7d ) has %8d digits\tafter %.3f secs"   ; Output with time since starting for remainder
                       (long i) (count (str p)) (elapsed-secs))))))
