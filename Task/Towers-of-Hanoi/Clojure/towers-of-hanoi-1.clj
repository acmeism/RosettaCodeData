(defn towers-of-hanoi [n from to via]
  (when (pos? n)
    (towers-of-hanoi (dec n) from via to)
    (printf "Move from %s to %s\n" from to)
    (recur (dec n) via to from)))
