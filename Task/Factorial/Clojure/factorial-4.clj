(defn factorial
  ([x] (trampoline factorial x 1))
  ([x acc]
   (if (< x 2)
     acc
     #(factorial (dec x) (*' acc x)))))
