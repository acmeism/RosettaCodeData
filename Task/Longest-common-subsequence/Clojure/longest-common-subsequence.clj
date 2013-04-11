(defn longest [xs ys] (if (> (count xs) (count ys)) xs ys))


(def lcs
  (memoize
   (fn [[x & xs] [y & ys]]
     (cond
      (or (= x nil) (= y nil) ) nil
      (= x y) (cons x (lcs xs ys))
      :else (longest (lcs xs  ys) (lcs xs ys))))))
