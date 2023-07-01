(defn multiply
  ([] 1)
  ([x] x)
  ([x y] (* x y))
  ([x y & more]
    (reduce * (* x y) more)))

(multiply 2 3 4 5)  ; 120
