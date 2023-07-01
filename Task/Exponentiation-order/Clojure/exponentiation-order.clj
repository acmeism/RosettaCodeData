(use 'clojure.math.numeric-tower)
;; (5**3)**2
(expt (expt 5 3) 2)      ; => 15625

;; 5**(3**2)
(expt 5 (expt 3 2))      ; => 1953125

;; (5**3)**2 alternative: use reduce
(reduce expt [5 3 2])  ; => 15625

;; 5**(3**2) alternative: evaluating right-to-left with reduce requires a small modification
(defn rreduce [f coll] (reduce #(f %2 %) (reverse coll)))
(rreduce expt [5 3 2]) ; => 1953125
