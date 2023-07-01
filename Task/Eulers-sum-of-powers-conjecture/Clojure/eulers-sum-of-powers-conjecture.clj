(ns test-p.core
  (:require [clojure.math.numeric-tower :as math])
  (:require [clojure.data.int-map :as i]))

(defn solve-power-sum [max-value max-sols]
  " Finds solutions by using method approach of EchoLisp
    Large difference is we store a dictionary of all combinations
    of y^5 - x^5 with the x, y value so we can simply lookup rather than have to search "
  (let [pow5 (mapv #(math/expt % 5) (range 0 (* 4 max-value)))                  ; Pow5 = Generate Lookup table for x^5
        y5-x3 (into (i/int-map) (for [x (range 1 max-value)                     ; For x0^5 + x1^5 + x2^5 + x3^5  = y^5
                                      y (range (+ 1 x) (* 4 max-value))]        ; compute y5-x3 = set of all possible differnences
                                  [(- (get pow5 y) (get pow5 x)) [x y]])) ; note: (get pow5 y) is closure for: pow5[y]
        solutions-found (atom 0)]

    (for [x0 (range 1 max-value)                                    ; Search over x0, x1, x2 for sums equal y5-x3
          x1 (range 1 x0)
          x2 (range 1 x1)
          :when (< @solutions-found max-sols)
          :let [sum (apply + (map pow5 [x0 x1 x2]))]         ; compute sum of items to the 5th power
          :when (contains? y5-x3 sum)]                       ; check if sum is in set of differences
      (do
        (swap! solutions-found inc)                          ; increment counter for solutions found
        (concat [x0 x1 x2] (get y5-x3 sum))))))              ; create result (since in set of differences)

; Output results with numbers in ascending order placing results into a set (i.e. #{}) so duplicates are discarded
                                                            ; CPU i7 920 Quad Core @2.67 GHz clock Windows 10
(println (into #{} (map sort (solve-power-sum 250 1))))   ; MAX = 250, find only 1 value: Duration was 0.26 seconds
(println (into #{} (map sort (solve-power-sum 1000 1000))));MAX = 1000, high max-value so all solutions found: Time = 4.8 seconds
