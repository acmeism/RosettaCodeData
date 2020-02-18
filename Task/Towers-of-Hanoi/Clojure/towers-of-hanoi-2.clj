(defn towers-of-hanoi [n from to via]
  (when (pos? n)
    (lazy-cat (towers-of-hanoi (dec n) from via to)
              (cons [from '-> to]
                    (towers-of-hanoi (dec n) via to from)))))
