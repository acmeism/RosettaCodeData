; Defines function named babbage? that returns true if the
; square of the provided number leaves a remainder of 269,696 when divided
; by a million
(defn babbage? [n]
  (let [square (* n n)]
    (= 269696 (mod square 1000000))))

; Use the above babbage? to find the first positive integer that returns true
; (We're exploiting Clojure's laziness here; (range) with no parameters returns
; an infinite series.)
(first (filter babbage? (range)))
