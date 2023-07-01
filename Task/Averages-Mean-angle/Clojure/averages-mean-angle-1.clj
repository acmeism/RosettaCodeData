(defn mean-fn
  [k coll]
  (let [n (count coll)
        trig (get {:sin #(Math/sin %) :cos #(Math/cos %)} k)]
    (* (/ 1 n) (reduce + (map trig coll)))))

(defn mean-angle
  [degrees]
  (let [radians (map #(Math/toRadians %) degrees)
        a (mean-fn :sin radians)
        b (mean-fn :cos radians)]
    (Math/toDegrees (Math/atan2 a b))))
