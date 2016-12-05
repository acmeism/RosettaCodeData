(defn cfrac
  [a b n]
  (letfn [(cfrac-iter [[x k]] [(+ (a k) (/ (b (inc k)) x)) (dec k)])]
    (ffirst (take 1 (drop (inc n) (iterate cfrac-iter [1 n]))))))

(def sq2 (cfrac #(if (zero? %) 1.0 2.0) (constantly 1.0) 100))
(def e (cfrac #(if (zero? %) 2.0 %) #(if (= 1 %) 1.0 (double (dec %))) 100))
(def pi (cfrac #(if (zero? %) 3.0 6.0) #(let [x (- (* 2.0 %) 1.0)] (* x x)) 900000))
