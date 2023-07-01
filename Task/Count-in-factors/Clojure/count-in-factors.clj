(ns listfactors
  (:gen-class))

(defn factors
  "Return a list of factors of N."
  ([n]
   (factors n 2 ()))
  ([n k acc]
   (cond
     (= n 1) (if (empty? acc)
               [n]
               (sort acc))
     (>= k n) (if (empty? acc)
                    [n]
                    (sort (cons n acc)))
    (= 0 (rem n k)) (recur (quot n k) k (cons k acc))
    :else (recur n (inc k) acc))))

(doseq [q (range 1 26)]
  (println q " = " (clojure.string/join " x "(factors q))))
