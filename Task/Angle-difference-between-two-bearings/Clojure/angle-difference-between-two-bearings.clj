(defn angle-difference [a b]
  (let [r (mod (- b a) 360)]
    (if (>= r 180)
      (- r 360)
      r)))

(angle-difference 20 45)  ; 25
(angle-difference -45 45) ; 90
(angle-difference -85 90) ; 175
(angle-difference -95 90) ; -175
(angle-difference -70099.74 29840.67) ; -139.59
