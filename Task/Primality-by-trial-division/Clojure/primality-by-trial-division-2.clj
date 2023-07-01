(defn prime? [x]
  (or (= 2 x)
      (and (< 1 x)
           (odd? x)
           (not-any? (partial divides? x)
                     (range 3 (inc (Math/sqrt x)) 2)))))
