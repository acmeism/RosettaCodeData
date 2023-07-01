(defn bubble-sort!
  [arr]
  (def arr-len (length arr))
  (when (< arr-len 2)
    (break arr))
  # at this point there are two or more elements
  (loop [i :down-to [(dec arr-len) 0]]
    (for j 0 i
      (def left-elt (get arr j))
      (def right-elt (get arr (inc j)))
      (when (> left-elt right-elt)
        (put arr j right-elt)
        (put arr (inc j) left-elt))))
  arr)

(comment

  (let [n 100
        arr (seq [i :range [0 n]]
              (* n (math/random)))]
    (deep= (bubble-sort! (array ;arr))
           (sort (array ;arr))))
  # => true

  )
