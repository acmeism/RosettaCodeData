(defn swap [v x y]
   (assoc! v y (v x) x (v y)))

(defn stooge-sort
  ([v] (persistent! (stooge-sort (transient v) 0 (dec (count v)))))
  ([v i j]
    (if (> (v i) (v j)) (swap v i j) v)
    (if (> (- j i) 1)
      (let [t (int (Math/floor (/ (inc (- j i)) 3)))]
        (stooge-sort v i (- j t))
        (stooge-sort v (+ i t) j)
        (stooge-sort v i (- j t))))
    v))
