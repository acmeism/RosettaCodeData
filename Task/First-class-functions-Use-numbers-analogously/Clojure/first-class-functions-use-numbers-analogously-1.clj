(def x  2.0)
(def xi 0.5)
(def y  4.0)
(def yi 0.25)
(def z  (+ x y))
(def zi (/ 1.0 (+ x y)))

(def numbers [x y z])
(def invers  [xi yi zi])

(defn multiplier [a b]
      (fn [m] (* a b m)))

> (for [[n i] (zipmap numbers invers)]
       ((multiplier n i) 0.5))
(0.5 0.5 0.5)
