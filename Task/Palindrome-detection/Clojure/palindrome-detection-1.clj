(defn palindrome? [s]
  (= s (apply str (reverse s))))
