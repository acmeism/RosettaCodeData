(defn ! [n]
  (reduce *
    (range 1 (inc n))
    1))

(print (! 6))  ; 720
(print (! 0))  ; 1
