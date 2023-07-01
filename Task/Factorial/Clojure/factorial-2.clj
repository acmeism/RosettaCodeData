(defn factorial [x]
  (if (< x 2)
      1
      (*' x (factorial (dec x)))))
