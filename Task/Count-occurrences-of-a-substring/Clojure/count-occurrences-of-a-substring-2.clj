(defn count-substring1 [txt sub]
  (/ (- (count txt) (count (.replaceAll txt sub "")))
     (count sub)))
