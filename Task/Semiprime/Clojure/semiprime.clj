(ns example
  (:gen-class))

(defn semi-prime? [n]
  (loop [a 2
         b 0
         c n]
    (cond
      (> b 2) false
      (<= c 1) (= b 2)
      (= 0 (rem c a)) (recur a (inc b) (int (/ c a)))
      :else (recur (inc a) b c))))

(println (filter semi-prime? (range 1 100)))
