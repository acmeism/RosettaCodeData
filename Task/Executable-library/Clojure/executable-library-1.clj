(ns rosetta-code.hailstone-sequence)

(defn next-in-hailstone
  "Returns the next number in the Hailstone sequence that starts with x.
  If x is less than 2, returns nil."
  [x]
  (when (> x 1)
    (if (even? x)
      (/ x 2)
      (inc (* 3 x)))))

(defn hailstone-seq
  "Returns a lazy Hailstone sequence starting with the number x."
  [x]
  (take-while some?
              (iterate next-in-hailstone x)))

(defn -main [& args]
  (let [h27 (hailstone-seq 27)]
    (printf "The Hailstone sequence starting at 27 contains %s elements:\n%s ... %s.\n"
            (count h27)
            (vec (take 4 h27))
            (vec (take-last 4 h27)))
    (let [[number length] (apply max-key second
                                 (map (fn [x] [x (count (hailstone-seq x))])
                                      (range 100000)))]
      (printf "The number %s has the longest Hailstone sequence under 100000, of length %s.\n"
              number length))))
