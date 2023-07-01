(defn dotp [a b]
  (assert (= (len a) (len b)))
  (sum (genexpr (* aterm bterm)
                [(, aterm bterm) (zip a b)])))

(assert (= 3 (dotp [1 3 -5] [4 -2 -1])))
