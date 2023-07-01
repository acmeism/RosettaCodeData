(import math)

(defn iterate [phi n]
  (setv phi1 (+ 1.0 (/ 1.0 phi)))
  (setv n1 (+ n 1))
  (if (<= (abs (- phi1 phi)) 1e-5)
    [phi1 n1]
    (iterate phi1 n1)))

(setv [phi n] (iterate 1.0 0))
(print "Result:" phi "after" n "iterations")
(print "The error is approximately"
       (- phi (* 0.5 (+ 1 (math.sqrt 5)))))
