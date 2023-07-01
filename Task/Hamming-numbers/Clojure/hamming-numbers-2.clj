(defn hamming
  "Computes the unbounded sequence of Hamming 235 numbers."
  []
  (letfn [(merge [xs ys]
            (if (nil? xs) ys
              (let [xv (first xs), yv (first ys)]
                (if (< xv yv) (cons xv (lazy-seq (merge (next xs) ys)))
                              (cons yv (lazy-seq (merge xs (next ys)))))))),
          (smult [m s] ;; equiv to map (* m) s -- faster
            (cons (*' m (first s)) (lazy-seq (smult m (next s))))),
          (u [s n] (let [r (atom nil)]
                      (reset! r (merge s (smult n (cons 1 (lazy-seq @r)))))))]
    (cons 1 (lazy-seq (reduce u nil (list 5 3 2))))))
