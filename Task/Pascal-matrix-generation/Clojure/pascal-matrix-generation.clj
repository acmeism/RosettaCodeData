(defn binomial-coeff [n k]
  (reduce #(quot (* %1 (inc (- n %2))) %2)
          1
          (range 1 (inc k))))

(defn pascal-upper [n]
  (map
   (fn [i]
     (map (fn [j]
            (binomial-coeff j i))
          (range n)))
   (range n)))

(defn pascal-lower [n]
  (map
   (fn [i]
     (map (fn [j]
            (binomial-coeff i j))
          (range n)))
   (range n)))

(defn pascal-symmetric [n]
  (map
   (fn [i]
     (map (fn [j]
            (binomial-coeff (+ i j) i))
          (range n)))
   (range n)))

(defn pascal-matrix [n]
  (println "Upper:")
  (run! println (pascal-upper n))
  (println)
  (println "Lower:")
  (run! println (pascal-lower n))
  (println)
  (println "Symmetric:")
  (run! println (pascal-symmetric n)))
