(defn factorial [x]
    (cond
        (< x 0) nil
        (= x 0) 1
        (product (range 1 (inc x)))))
