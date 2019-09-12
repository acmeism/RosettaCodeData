(defn experiment
  []
  (if (<= (+ (Math/pow (rand) 2) (Math/pow (rand) 2)) 1) 1 0))

(defn pi-estimate
  [n]
  (* 4 (float (/ (reduce + (take n (repeatedly experiment))) n))))

(pi-estimate 10000)
