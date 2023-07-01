(defn solve [m]
  (assert (<= 1 m 2))
  (let [n  (- 3 m)
        v0 (scale (eqn1 n) eqn0)
        v1 (scale (eqn0 n) eqn1)
        vd (minus v0 v1)]
    (assert (zero? (vd n)))
    (/ (- (vd 0)) (vd m))))

(let [x (solve 1), z (solve 2), y (+ x z)]
  (println "x =" x ", y =" y ", z =" z))
