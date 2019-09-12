(defn palindrome? [^String s]
  (loop [front 0 back (dec (.length s))]
    (or (>= front back)
        (and (= (.charAt s front) (.charAt s back))
             (recur (inc front) (dec back)))))
