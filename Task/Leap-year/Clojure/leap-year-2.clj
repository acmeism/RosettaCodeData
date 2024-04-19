(defn leap-year? [y]
  (condp #(zero? (mod %2 %1)) y
    400 true
    100 false
    4   true
    false))
