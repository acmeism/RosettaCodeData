(defn smerge [xs ys]
  (lazy-seq
    (let [x (first xs),
          y (first ys),
          [z xs* ys*]
          (cond
            (< x y) [x (rest xs) ys]
            (> x y) [y xs (rest ys)]
            :else   [x (rest xs) (rest ys)])]
      (cons z (smerge xs* ys*)))))

(def hamming
  (lazy-seq
    (->> (map #(*' 5 %) hamming)
         (smerge (map #(*' 3 %) hamming))
         (smerge (map #(*' 2 %) hamming))
         (cons 1))))
