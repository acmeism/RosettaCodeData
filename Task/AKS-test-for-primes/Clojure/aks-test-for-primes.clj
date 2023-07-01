(defn c
  "kth coefficient of (x - 1)^n"
  [n k]
  (/ (apply *' (range n (- n k) -1))
     (apply *' (range k 0 -1))
     (if (and (even? k) (< k n)) -1 1)))

(defn cs
  "coefficient series for (x - 1)^n, k=[0..n]"
  [n]
  (map #(c n %) (range (inc n))))

(defn aks? [p] (->> (cs p) rest butlast (every? #(-> % (mod p) zero?))))

(println "coefficient series n (k[0] .. k[n])")
(doseq [n (range 10)] (println n (cs n)))
(println)
(println "primes < 50 per AKS:" (filter aks? (range 2 50)))
