(defn reverse-string [s]
  "Returns a string with all characters in reverse"
  (apply str (reduce conj '() s)))
