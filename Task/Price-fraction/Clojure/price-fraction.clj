(def values [10 18 26 32 38 44 50 54 58 62 66 70 74 78 82 86 90 94 98 100])

(defn price [v]
  (format "%.2f" (double (/ (values (int (/ (- (* v 100) 1) 5))) 100))))
