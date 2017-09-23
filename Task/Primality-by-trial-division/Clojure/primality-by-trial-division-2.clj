(defn prime? [x]
  (or (= 2 x)
      (= 3 x)
      (and (< 1 x)
           (odd? x)
           (not-any? (partial divides? x)
                     (range 3 (math/sqrt x) 2)))))
