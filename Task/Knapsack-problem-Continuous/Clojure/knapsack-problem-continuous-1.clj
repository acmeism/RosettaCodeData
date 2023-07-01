; Solve Continuous Knapsack Problem
; Nicolas Modrzyk
; January 2015

(def maxW 15.0)
(def items
  {:beef    [3.8 36]
   :pork    [5.4 43]
   :ham     [3.6 90]
   :greaves [2.4 45]
   :flitch  [4.0 30]
   :brawn   [2.5 56]
   :welt    [3.7 67]
   :salami  [3.0 95]
   :sausage [5.9 98]})

(defn rob [items maxW]
  (let[
    val-item
        (fn[key]
          (- (/ (second (items key)) (first (items key )))))
    compare-items
        (fn[key1 key2]
          (compare (val-item key1) (val-item key2)))
    sorted (into (sorted-map-by compare-items) items)]

  (loop [current (first sorted)
         array (rest sorted)
         value 0
         weight 0]
    (let[new-weight (first (val current))
         new-value (second (val current))]
    (if (> (- maxW weight new-weight) 0)
      (do
        (println "Take all " (key current))
        (recur
         (first array)
         (rest array)
         (+ value new-value)
         (+ weight new-weight)))
      (let [t (- maxW weight)] ; else
      (println
       "Take " t " of "
       (key current) "\n"
       "Total Value is:"
       (+ value (* t (/ new-value new-weight))))))))))

(rob items maxW)
