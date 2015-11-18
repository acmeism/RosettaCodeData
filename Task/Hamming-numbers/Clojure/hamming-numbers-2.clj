(defn hamming
  "Computes the unbounded sequence of Hamming 235 numbers."
  []
  (letfn [(merge [xs ys]
            (let [xv (first xs), yv (first ys)]
              (if (< xv yv) (cons xv (lazy-seq (merge (next xs) ys)))
                            (cons yv (lazy-seq (merge xs (next ys))))))),
          (smult [m s] ;; equiv to map (* m) s -- faster
            (cons (*' m (first s)) (lazy-seq (smult m (next s)))))]
    (do (def s5 (cons 5 (lazy-seq (smult 5 s5))))
        (def s35 (cons 3 (lazy-seq (merge s5 (smult 3 s35)))))
        (def s235 (cons 2 (lazy-seq (merge s35 (smult 2 s235)))))
        (cons 1 (lazy-seq s235)))))
